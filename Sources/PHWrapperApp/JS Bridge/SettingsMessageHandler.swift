//
//  SettingsMessageHandler.swift
//  PHWrapperApps
//
//  Created by Benjamin Böcker on 02.02.21.
//  Copyright © 2021 Palasthotel. All rights reserved.
//

import Foundation
import WebKit
import Inject


final class SettingsMessageHandler: NSObject, MessageHandler {
	var functionNames: [String] { ["getSettingsURL", "openSettingsPage"] }
}

extension SettingsMessageHandler {
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		guard let data = message.body as? [String: Any] else { return }
		guard let index = data["idx"] as? Int else { return }
		guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }

		switch message.name {
		case "getSettingsURL":
			message.webView?.callback(index: index, value: settingsURL.absoluteString)
		case "openSettingsPage":
			UIApplication.shared.open(settingsURL, options: [:])
		default: return
		}
	}
}

