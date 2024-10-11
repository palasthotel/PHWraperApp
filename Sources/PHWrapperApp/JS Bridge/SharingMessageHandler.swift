//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 06.05.24.
//

import Foundation
import WebKit


final class SharingMessageHandler: NSObject, MessageHandler {
	
}


extension SharingMessageHandler {
	var functionNames: [String] { [
		"share",
		"shareCurrentURL"
	] }
	
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		guard let data = message.body as? [String: Any],
			  let urlString = data["url"] as? String,
			  let url = URL(string: urlString)
		else {
			return
		}
		
		let items = [url]
		let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
		webViewController?.present(ac, animated: true)
	}
}



