//
//  NotificationManager.swift
//  
//
//  Created by Benjamin Böcker on 03.08.21.
//

import Foundation
import FirebaseMessaging
import Foundation
import UIKit
import Inject


enum NotificationStatus: String {
	case open, allowed, denied
}


protocol NotificationManager {
	func subscribe(to topic: String)
	func unsubscribe(from topic: String)
	func isSubscribed(to topic: String) -> Bool
	func getNotificationStatus(completion: @escaping (NotificationStatus) -> Void)

	/// Sets the necessary delegates and asks the system for authorization to use push notifications.
	func requestAuthorization(completion: @escaping (NotificationStatus) -> Void)
	var onMessageReceived: ((URL) -> Void)? { get set }
}

extension UserDefaults.Key {
	static var topics: UserDefaults.Key { "topics" }
}



class NotificationManagerComponent: NSObject {
	private var savedURL: URL? {
		didSet {
			guard let onMessageReceived = onMessageReceived,
				  let savedURL = savedURL else { return }
			onMessageReceived(savedURL)
		}
	}

	var onMessageReceived: ((URL) -> Void)? {
		didSet {
			if savedURL != nil {
				onMessageReceived!(savedURL!)
				savedURL = nil
			}
		}
	}

	required override init() {
		super.init()
		
		UserDefaults.standard.register(keyedDefaults: [
			.topics: []
		])
	}
	
	func onResolved() {
		let topics = subscribedTopics()
		for topic in topics {
			subscribe(to: topic)
		}
		
	}
}

// MARK: - NotificationsHandler
extension NotificationManagerComponent: NotificationManager {
	func getNotificationStatus(completion: @escaping (NotificationStatus) -> Void) {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			DispatchQueue.main.async {
				switch settings.authorizationStatus {
				case .denied: completion(.denied)
				case .notDetermined: completion(.open)
				default: completion(.allowed)
				}
			}
		}
	}
	
	func requestAuthorization(completion: @escaping (NotificationStatus) -> Void) {
		UNUserNotificationCenter.current().delegate = self

		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		
		UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
			DispatchQueue.main.async {
				if granted && error == nil {
					UIApplication.shared.registerForRemoteNotifications()
				}
				
				self.getNotificationStatus { status in
					completion(status)
				}
			}
		}
	}

	func subscribe(to topic: String) {
		var topics = subscribedTopics()
		if !topics.contains(topic) {
			topics.append(topic)
		}
		UserDefaults.standard.set(topics, for: .topics)
		
		print("Subscribing to '\(topic)'")
		
		Messaging.messaging().subscribe(toTopic: topic)
	}

	func unsubscribe(from topic: String) {
		var topics = subscribedTopics()
		topics.removeAll { $0 == topic }
		
		UserDefaults.standard.set(topics, for: .topics)
		
		print("Unsubscribing from '\(topic)'")
		Messaging.messaging().unsubscribe(fromTopic: topic)
	}

	func isSubscribed(to topic: String) -> Bool {
		return subscribedTopics().contains(topic)
	}
	
	func subscribedTopics() -> [String] {
		let topics: [String] = UserDefaults.standard.get(valueFor: .topics)
		return Array(Set(topics))
	}
}



// MARK: - UNUserNotificationCenterDelegate
extension NotificationManagerComponent: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert])
	}
	
	func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let content = response.notification.request.content
		
		guard let permalink = content.userInfo["permalink"] as? String else {
			completionHandler()
			return
		}
		
		guard let url = URL(string: permalink) else {
			completionHandler()
			return
		}
		
		if onMessageReceived == nil {
			savedURL = url
		} else {
			onMessageReceived?(url)
		}
		
		completionHandler()
	}
}

