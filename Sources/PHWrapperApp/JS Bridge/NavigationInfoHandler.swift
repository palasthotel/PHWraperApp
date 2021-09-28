//
//  NavigationInfoHandler.swift
//  PHWrapperApps
//
//  Created by Benni on 11.11.20.
//  Copyright © 2020 Palasthotel. All rights reserved.
//

import Foundation
import WebKit
import Inject


final class NavigationInfoHandler: NSObject, MessageHandler {
	@Inject var config: AppConfig
}


extension NavigationInfoHandler {
	var functionNames: [String] { ["hasNoNativeNavigation"] }

	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		guard let data = message.body as? [String: Any] else { return }
		guard let index = data["idx"] as? Int else { return }

		// !!! The callback asks for NO native navigation, so we must negate the config value!
		let hasNoNativeNavigation = !config.hasNativeNavigationBar
		message.webView?.callback(index: index, value: hasNoNativeNavigation ? "true" : "false")
	}
}
