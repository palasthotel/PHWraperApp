//
//  WebMessageHandler.swift
//  Zentralplus
//
//  Created by Benni on 31.05.19.
//  Copyright © 2019 BenBoecker. All rights reserved.
//

import Foundation
import WebKit
import Inject


public protocol MessageHandler: WKScriptMessageHandler {
	var functionNames: [String] { get }
}

extension WKWebView {
	func callback(index: Int, value: String) {
		evaluateJavaScript("iOSNotifications.callback(\(index), '\(value)');", completionHandler: nil);
	}
}



extension MessageHandler {
	var webViewController: WebViewController? {
		let scene = UIApplication.shared.connectedScenes.first {
			guard let scene = $0 as? UIWindowScene else {
				return false
			}
			
			let window = scene.windows.first {
				$0.rootViewController is WebViewController
			}
			
			return window != nil
		} as? UIWindowScene
		
		let viewController = scene?.windows.first?.rootViewController as? WebViewController
		
		return viewController
	}
}
