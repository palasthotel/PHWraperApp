//
//  WebMessageHandler.swift
//  Zentralplus
//
//  Created by Benni on 31.05.19.
//  Copyright © 2019 BenBoecker. All rights reserved.
//

import Foundation
import WebKit
import Inject


public protocol MessageHandler: WKScriptMessageHandler {
	var functionNames: [String] { get }
}

extension WKWebView {
	func callback(index: Int, value: String) {
		evaluateJavaScript("iOSNotifications.callback(\(index), '\(value)');", completionHandler: nil);
	}
}


