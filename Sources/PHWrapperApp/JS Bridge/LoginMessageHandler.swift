//
//  LoginMessageHandler.swift
//  Zentralplus
//
//  Created by Benni on 31.05.19.
//  Copyright © 2019 BenBoecker. All rights reserved.
//

import Foundation
import WebKit
import FirebaseCore
import FirebaseAuth


final class LoginMessageHandler: NSObject, MessageHandler {

}


extension LoginMessageHandler {
	var functionNames: [String] { [
		"setLoggedIn",
		"signIn",
		"signOut",
		"uid"
	] }

	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		switch message.name {
		case "setLoggedIn":
			if let data = message.body as? [String: Any],
			   let isLoggedIn = data["isLoggedIn"] as? Bool {
				UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
			}
		case "signIn":
			guard let data = message.body as? [String: Any],
				  let loginToken = data["token"] as? String
			else {
				print("got no login token")
				return
			}
			
			UserDefaults.standard.set(true, forKey: "isLoggedIn")
			
			Task.detached {
				do {
					try await PHFirebase.signIn(with: loginToken)
				} catch {
					print("\(error)")
				}
			}			
			
		case "signOut":
			UserDefaults.standard.set(false, forKey: "isLoggedIn")
			
			Task.detached {
				do {
					try await PHFirebase.signOut()
				} catch {
					print("\(error)")
				}
			}
			
		case "uid":
			guard let data = message.body as? [String: Any] else { return }
			guard let index = data["idx"] as? Int else { return }

			if let uid = PHFirebase.userID {
				message.webView?.callback(index: index, value: uid)
			} else {
				message.webView?.callback(index: index, value: "")
			}
		default:
			return
		}
	}
}
