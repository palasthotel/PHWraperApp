//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 28.07.21.
//

import Foundation
import Inject
import UIKit


public protocol AppConfig {
	var hasNativeNavigationBar: Bool { get }
	var supportsNativeReload: Bool { get }
	var applicationTintColor: UIColor { get }
	var credentials: (user: String, password: String) { get }
	var additionalUserScripts: [String] { get }
	var additionalMessageHandlers: [MessageHandler] { get }
}


public extension AppConfig {
	var hasNativeNavigationBar: Bool {
		false
	}
	var supportsNativeReload: Bool {
		false
	}
	var applicationTintColor: UIColor {
		.link
	}
	var additionalUserScripts: [String] {
		[]
	}
	var additionalMessageHandlers: [MessageHandler] {
		[]
	}
}
