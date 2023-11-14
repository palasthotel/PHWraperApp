//
//  NotificationsMessageHandler.swift
//  PHWrapperApps
//
//  Created by Benni on 16.01.20.
//  Copyright © 2020 Palasthotel. All rights reserved.
//

import Foundation
import WebKit
import Inject


final class NotificationsMessageHandler: NSObject, MessageHandler {
	var functionNames: [String] { [
		"subscribe",
		"unsubscribe",
		"isSubscribed",
		"getNotificationsStatus",
		"requestNotificationsPermission",
		"isNotificationsEnabled",
		"setNotificationsEnabled",
	] }
	
	@Inject var notificationManager: NotificationManager
}

extension NotificationsMessageHandler {
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		guard let data = message.body as? [String: Any] else { return }
		guard let index = data["idx"] as? Int else { return }
		guard let topic = data["topic"] as? String else { return }
		
		switch message.name {
		case "subscribe":
			notificationManager.subscribe(to: topic)
			message.webView?.callback(index: index, value: "true")
		case "unsubscribe":
			notificationManager.unsubscribe(from: topic)
			message.webView?.callback(index: index, value: "true")
		case "isSubscribed":
			let isSubscribed = notificationManager.isSubscribed(to: topic)
			message.webView?.callback(index: index, value: isSubscribed ? "true" : "false")
		case "getNotificationsStatus":
			notificationManager.getNotificationStatus { status in
				message.webView?.callback(index: index, value: status.rawValue)
			}
		case "requestNotificationsPermission":
			notificationManager.requestAuthorization { status in
				message.webView?.callback(index: index, value: status.rawValue)
			}
		case "isNotificationsEnabled":
			notificationManager.getNotificationStatus { status in
				switch status {
				case .allowed:
					message.webView?.callback(index: index, value: "true")
				default:
					message.webView?.callback(index: index, value: "false")
				}
			}
		case "setNotificationsEnabled":
			notificationManager.requestAuthorization { status in
				switch status {
				case .allowed:
					message.webView?.callback(index: index, value: "true")
				default:
					message.webView?.callback(index: index, value: "false")
				}
			}
		default:
			print("Message: '\(message.name)' not handled")
			break
		}
	}
}
