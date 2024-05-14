//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 30.04.24.
//

import Foundation
import WebKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


final class DeviceIdentifierMessageHandler: NSObject, MessageHandler {

}


extension DeviceIdentifierMessageHandler {
	var functionNames: [String] { [
		"deviceId",
	] }
	
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		guard let data = message.body as? [String: Any],
			  let index = data["idx"] as? Int
		else {
			return
		}
		
		if let deviceID = DeviceID.id {
			message.webView?.callback(index: index, value: deviceID)
		}
	}
}
