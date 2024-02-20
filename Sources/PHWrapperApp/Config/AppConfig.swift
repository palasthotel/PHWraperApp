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
				reloadAfterTimeInterval: TimeInterval? = nil
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
	}
	
	/// Currently not supported
	var hasNativeNavigationBar: Bool
	
	/// Currently not supported
	var supportsNativeReload: Bool
	
	/// Currently not supported
	var applicationTintColor: UIColor
	
	/// Login credentials to bypass .htaccess protection
	var credentials: (user: String, password: String)
	
	/// Filenames of additional .js scripts in the main bundle
	var additionalUserScripts: [String]
	
	/// Instances of additional handlers for WebKit communication. Must implement the `MessageHandler` protocol.
	var additionalMessageHandlers: [MessageHandler]
	
	/// If set, the web app subscribes to this messaging topic. For testing purposes only.
	var testTopic: String?
	
	/// Defines if the app should ask the user for notification access automatically on the first launch of the app.
	var requestNotificationAccessOnStart: Bool
	
	/// If this property is set, the webview reloads after the app has spent at least the specified amount of time in the background.
	var reloadAfterTimeInterval: TimeInterval?
}
