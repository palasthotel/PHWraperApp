//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 28.07.21.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import Inject
import RevenueCat


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
		
		@Inject var appConfig: AppConfig
		if !appConfig.revenueCatAPIKey.isEmpty, let userID = PHFirebase.userID {
			Purchases.configure(withAPIKey: appConfig.revenueCatAPIKey, appUserID: userID)
			Purchases.shared.logIn(userID) { customerInfo, som, err in
				if let err {
					print("\(err)")
				}
			}
		}

	}
	
	static func disableLogging() {
		FirebaseConfiguration.shared.setLoggerLevel(.min)
	}
	
	static var userID: String? {
		Auth.auth().currentUser?.uid
	}
	
	static func signIn(with loginToken: String) async throws {
		try await Auth.auth().signIn(withCustomToken: loginToken)
		
		guard let userID else {
			return
		}
		
		let devices = Firestore.firestore().collection("users").document(userID).collection("devices")
		
		let messagingToken = Messaging.messaging().fcmToken ?? ""
		
		if let deviceID = DeviceID.id {
			let device = try await devices.document(deviceID).getDocument()
			
			if device.exists {
				if let deviceMessagingToken = device["token"] as? String, deviceMessagingToken == messagingToken {
					return
				} else {
					try await device.reference.setData([
						"token": messagingToken
					])
				}
			}
		}
		
		let doc = try await devices
			.addDocument(data: [
				"created": FieldValue.serverTimestamp(),
				"token": messagingToken,
				"type": "ios",
			])
		
		DeviceID.id = doc.documentID
		
		@Inject var config: AppConfig
		if !config.revenueCatAPIKey.isEmpty {
			Purchases.configure(withAPIKey: config.revenueCatAPIKey, appUserID: userID)
			let _ = try await Purchases.shared.logIn(userID)
		}
	}
	
	static func updateFCMToken() async throws {
		guard let userID, let deviceID = DeviceID.id else {
			return
		}
		
		let messagingToken = Messaging.messaging().fcmToken ?? ""
		
		try await Firestore.firestore()
			.collection("users")
			.document(userID)
			.collection("devices")
			.document(deviceID)
			.setData([
				"token": messagingToken
			])
	}
	
	static func signOut() async throws {
		if let deviceID = DeviceID.id, let userID {
			let existingDevice = Firestore.firestore()
				.collection("users")
				.document(userID)
				.collection("devices")
				.document(deviceID)
			
			try await existingDevice.delete()
			try Auth.auth().signOut()
			DeviceID.id = nil
		} else {
			print("Device ID: \(DeviceID.id), User ID: \(userID)")
		}
	}
}

private extension PHFirebase {
	
}
