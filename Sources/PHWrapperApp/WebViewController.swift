//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 28.07.21.
//

import Foundation
import UIKit
import WebKit
import Inject
import StoreKit
import FirebaseCore


class WebViewController: UIViewController {
	private var webView = WKWebView()
	private var refreshControl = UIRefreshControl()
	private var progressView = UIProgressView()
	private var statusBarHeightConstraint = NSLayoutConstraint()
	
	private var handlers: [MessageHandler] = [
		LoginMessageHandler(),
		NavigationInfoHandler(),
		NotificationsMessageHandler(),
		SettingsMessageHandler(),
	]

	
	private let firebaseConfig: FirebaseConfig
	@Inject private var appConfig: AppConfig
	@MutableInject private var notificationManager: NotificationManager

	private var eventHandlers = EventHandlers()
	private var loadingObserver: NSKeyValueObservation!
	private var progressObserver: NSKeyValueObservation!

	init() {
		PHFirebase.configure()
		
		self.firebaseConfig = FirebaseConfig()
		
		super.init(nibName: nil, bundle: nil)
		
		handlers += appConfig.additionalMessageHandlers
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
	deinit {
		loadingObserver.invalidate()
		progressObserver.invalidate()
	}
}


//MARK: - UIViewController overrides
extension WebViewController {
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		
		firebaseConfig.fetch {
			if let url = self.firebaseConfig.getURL(for: .startURL) {
				self.navigationItem.leftBarButtonItem?.isEnabled = true
				self.load(url)
			}
		}
		
		if Bundle.main.bundleIdentifier == "com.pocketscience.zentralplus" {
			
			notificationManager.requestAuthorization { _ in }
		}

	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
		statusBarHeightConstraint.constant = statusBarHeight
	}
}


//MARK: - Public methods and properties
extension WebViewController {
	func load(_ url: URL) {
		print("Loading: \(url.absoluteString)")
		webView.load(URLRequest(url: url))

		notificationManager.subscribe(to: "TEST-09-2021")
		
		showRatingController()
	}

	func goBack() {
		if webView.canGoBack {
			webView.goBack()
		} else if let url = self.firebaseConfig.getURL(for: .startURL) {
			self.load(url)
		}
	}
}

//MARK: - Private methods and properties
private extension WebViewController {
	func setupViews() {
		configureWebView()
		configureProgressView()
		configureRefreshControl()
		
		let stackView = UIStackView(arrangedSubviews: [progressView, webView])
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		
//		let overlayView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
		let overlayView = UIView()
		overlayView.backgroundColor = .systemBackground
		overlayView.translatesAutoresizingMaskIntoConstraints = false
		statusBarHeightConstraint = overlayView.heightAnchor.constraint(equalToConstant: 0.0)
		view.addSubview(overlayView)

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			progressView.heightAnchor.constraint(equalToConstant: 8.0),

			overlayView.topAnchor.constraint(equalTo: view.topAnchor),
			overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			statusBarHeightConstraint,
		])
	}
	
	func configureProgressView() {
		progressView.progressTintColor = appConfig.applicationTintColor
	}
	
	func configureRefreshControl() {
		if #available(iOS 14.0, *) {
			refreshControl.addAction(UIAction { [weak self] _ in
				self?.webView.isUserInteractionEnabled = false
				self?.webView.reload()
			}, for: .valueChanged)
		} else {
			refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
		}
		refreshControl.tintColor = appConfig.applicationTintColor
	}
	
	func configureWebView() {
		webView.navigationDelegate = self
		webView.uiDelegate = self
		webView.allowsLinkPreview = false

		if appConfig.supportsNativeReload {
			webView.scrollView.refreshControl = refreshControl
		} else {
			webView.scrollView.refreshControl = nil
		}

		loadingObserver = webView.observe(\WKWebView.isLoading, options: .new) { [weak self] (webView, changes) in
			guard let self = self, let isLoading = changes.newValue else {
				return
			}

			if self.refreshControl.isRefreshing == true && !isLoading {
				self.refreshControl.endRefreshing()
				self.webView.isUserInteractionEnabled = true
			}

			guard let url = webView.url else { return }
			self.setProgressView(visible: isLoading)
			if isLoading {
				self.eventHandlers.loadingStarted?(url)
			} else {
				self.eventHandlers.loadingFinished?(url)
			}
		}
		progressObserver = webView.observe(\WKWebView.estimatedProgress, options: .new) { [weak self] (webView, changes) in
			guard let self = self, let progress = changes.newValue else {
				return
			}
			self.eventHandlers.loadingProgress?(Float(progress))
			self.progressView.progress = Float(progress)
		}
		
		if let scriptURL = Bundle.module.url(forResource: "iOSNotifications", withExtension: "js"),
		   let js = try? String(contentsOf: scriptURL) {
			let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
			webView.configuration.userContentController.addUserScript(script)
		}
		
		for filename in appConfig.additionalUserScripts {
			if let scriptURL = Bundle.main.url(forResource: filename, withExtension: "js"),
			   let js = try? String(contentsOf: scriptURL) {
				let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
				webView.configuration.userContentController.addUserScript(script)
			}
		}
		
		for handler in handlers {
			for name in handler.functionNames {
				webView.configuration.userContentController.add(handler, name: name)
			}
		}

		notificationManager.onMessageReceived = { [weak self] url in
			self?.load(url)
		}
		
		
	}

	@objc func onRefresh(_ sender: Any) {
		webView.isUserInteractionEnabled = false
		webView.reload()
	}

	func showRatingController() {
//		if AppConfig().shouldShowReviewPrompt {
//			let oneSecondFromNow = DispatchTime.now() + 1.0
//			DispatchQueue.main.asyncAfter(deadline: oneSecondFromNow) {
//				SKStoreReviewController.requestReview()
//			}
//		}
	}
	
	func setProgressView(visible: Bool) {
		progressView.isHidden = !visible
		view.setNeedsLayout()
		
		UIView.animate(withDuration: 0.25) {
			self.view.layoutIfNeeded()
		}
	}
	
}


// MARK: - WKUIDelegate, WKNavigationDelegate
extension WebViewController: WKUIDelegate, WKNavigationDelegate {
	public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		guard navigationAction.navigationType == .linkActivated else {
			decisionHandler(.allow)
			return
		}

		guard let destinationURL = navigationAction.request.url else {
			decisionHandler(.cancel)
			return
		}

		if firebaseConfig.isBlacklisted(destinationURL) ||
			destinationURL.path.starts(with: "/ads/") {
			UIApplication.shared.open(destinationURL, options: [:])
			decisionHandler(.cancel)
			return
		}

		if firebaseConfig.isWhitelisted(destinationURL) {
			decisionHandler(.allow)
			return
		}

		UIApplication.shared.open(destinationURL, options: [:])
		decisionHandler(.cancel)
	}

	public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("\(error)")
	}

	public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let credential = URLCredential(user: appConfig.credentials.user, password: appConfig.credentials.password, persistence: .forSession);
		completionHandler(.useCredential,credential);
	}

}


extension WebViewController {
	struct EventHandlers {
		var loadingStarted: ((URL) -> Void)?
		var loadingProgress: ((Float) -> Void)?
		var loadingFinished: ((URL) -> Void)?
	}
}
