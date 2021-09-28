//
//  LoginMessageHandler.swift
//  Zentralplus
//
//  Created by Benni on 31.05.19.
//  Copyright © 2019 BenBoecker. All rights reserved.
//

import Foundation
import WebKit


final class LoginMessageHandler: NSObject, MessageHandler {

}


extension LoginMessageHandler {
	var functionNames: [String] { ["setLoggedIn"] }

	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		if let data = message.body as? [String: Any],
			let isLoggedIn = data["isLoggedIn"] as? Bool {
			UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
		}
	}
}
