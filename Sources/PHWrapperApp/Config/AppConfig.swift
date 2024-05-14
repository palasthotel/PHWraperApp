//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 28.07.21.
//

import Foundation
import Inject
import UIKit


public struct AppConfig {
	
	public init(hasNativeNavigationBar: Bool = false,
				supportsNativeReload: Bool = false,
				applicationTintColor: UIColor = .link,
				credentials: (user: String, password: String),
				additionalUserScripts: [String] = [],
				additionalMessageHandlers: [MessageHandler] = [],
				testTopic: String? = nil,
				requestNotificationAccessOnStart: Bool = false,
				reloadAfterTimeInterval: TimeInterval? = nil,
				revenueCatAPIKey: String = ""
	) {
		self.hasNativeNavigationBar = hasNativeNavigationBar
		self.supportsNativeReload = supportsNativeReload
		self.applicationTintColor = applicationTintColor
		self.credentials = credentials
		self.additionalUserScripts = additionalUserScripts
		self.additionalMessageHandlers = additionalMessageHandlers
		self.testTopic = testTopic
		self.requestNotificationAccessOnStart = requestNotificationAccessOnStart
		self.reloadAfterTimeInterval = reloadAfterTimeInterval
		self.revenueCatAPIKey = revenueCatAPIKey
	}
	
	/// Currently not supported
	let hasNativeNavigationBar: Bool
	
	/// Currently not supported
	let supportsNativeReload: Bool
	
	/// Currently not supported
	let applicationTintColor: UIColor
	
	/// Login credentials to bypass .htaccess protection
	let credentials: (user: String, password: String)
	
	/// Filenames of additional .js scripts in the main bundle
	let additionalUserScripts: [String]
	
	/// Instances of additional handlers for WebKit communication. Must implement the `MessageHandler` protocol.
	let additionalMessageHandlers: [MessageHandler]
	
	/// If set, the web app subscribes to this messaging topic. For testing purposes only.
	let testTopic: String?
	
	/// Defines if the app should ask the user for notification access automatically on the first launch of the app.
	let requestNotificationAccessOnStart: Bool
	
	/// If this property is set, the webview reloads after the app has spent at least the specified amount of time in the background.
	let reloadAfterTimeInterval: TimeInterval?
	
	let revenueCatAPIKey: String
}
