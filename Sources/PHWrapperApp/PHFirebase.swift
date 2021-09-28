//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 28.07.21.
//

import Foundation
import FirebaseCore


enum PHFirebase {
	
}

extension PHFirebase {
	/// Configures the Firebase App with the config file at the given path.
	/// parameter with: An optional `String` value that points to the config file. If nil is passed or the parameter is omitted, the default file named `GoogleService-Info.plist` is used.
	static func configure(with configFilePath: String? = nil) {
		if let path = configFilePath, let options = FirebaseOptions(contentsOfFile: path) {
			FirebaseApp.configure(options: options)
		} else {
			FirebaseApp.configure()
		}
	}
	
	static func disableLogging() {
		FirebaseConfiguration.shared.setLoggerLevel(.min)
	}
}
