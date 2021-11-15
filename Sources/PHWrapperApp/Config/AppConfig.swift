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
				additionalMessageHandlers: [MessageHandler] = []
	) {
		self.hasNativeNavigationBar = hasNativeNavigationBar
		self.supportsNativeReload = supportsNativeReload
		self.applicationTintColor = applicationTintColor
		self.credentials = credentials
		self.additionalUserScripts = additionalUserScripts
		self.additionalMessageHandlers = additionalMessageHandlers
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
}
