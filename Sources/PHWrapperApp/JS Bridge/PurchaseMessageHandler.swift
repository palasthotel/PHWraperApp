//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 06.05.24.
//

import Foundation
import WebKit
import StoreKit
import RevenueCat
import Inject


final class PurchaseMessageHandler: NSObject, MessageHandler {
	@Inject private var config: AppConfig
}


extension PurchaseMessageHandler {
	var functionNames: [String] { [
		"purchase",
		"launchAppStoreSubscriptions"
	] }
	
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		guard let data = message.body as? [String: Any] else { return }
		
		switch message.name {
		case "purchase":
			guard let offeringId = data["offeringId"] as? String else { return }
			
			purchase(offeringId, packageID: "")
		case "launchAppStoreSubscriptions":
			launchAppStoreSubscriptions()
		default:
			break
		}
	}
}

private extension PurchaseMessageHandler {
	func purchase(_ offeringID: String, packageID: String) {
		guard PHFirebase.isLoggedIn else {
			return
		}
		
		Task.detached { @MainActor [weak self] in
			do {
				if let apiKey = self?.config.revenueCatAPIKey, !apiKey.isEmpty, let uid = PHFirebase.userID, !Purchases.isConfigured {
					Purchases.configure(withAPIKey: apiKey, appUserID: uid)
#if DEBUG
					Purchases.logLevel = .verbose
#endif
				}
				
				let offerings = try await Purchases.shared.offerings()
				
				if let offering = offerings.offering(identifier: offeringID),
				   let package = offering.availablePackages.first {
					let result = try await Purchases.shared.purchase(package: package)
				}
			} catch {
				print("\(error)")
			}
		}
	}
	
	func launchAppStoreSubscriptions() {
		Task.detached { @MainActor in
			let scene = UIApplication.shared.connectedScenes.first { $0.isFirstResponder } as? UIWindowScene
			guard let scene else { return }
			
			try? await AppStore.showManageSubscriptions(in: scene)
		}
	}
}




