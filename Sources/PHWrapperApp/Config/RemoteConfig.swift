//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 28.07.21.
//

import Foundation
import Inject
import FirebaseRemoteConfig


class FirebaseConfig {
	var remoteConfig = RemoteConfig.remoteConfig()
		
	init() {
		remoteConfig.configSettings = RemoteConfigSettings()
		remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaultValues")
	}
}


extension FirebaseConfig {
	func fetch(completion: @escaping () -> Void) {
		remoteConfig.fetchAndActivate { (status, error) in
			if let error = error {
				print("\(error)")
			}
			
			DispatchQueue.main.async {
				completion()
			}
		}
	}
		
	func getURL(for key: RemoteConfigKey) -> URL? {
		if let urlString = UserDefaults.standard.string(forKey: "overrideStartURL"),
		   let url = URL(string: urlString) {
			return url
		}
		
		guard let urlString = remoteConfig.configValue(forKey: key).stringValue else {
			print("remote config value not found")
			return nil
		}

		guard let url = URL(string: urlString) else {
			print("could not create URL from: '\(urlString)'")
			return nil
		}
		
		return url
	}

	func isWhitelisted(_ url: URL) -> Bool {
		let whiteList = getURLList(for: .whitelist)
		
		for whiteListURL in whiteList where
			url.host == whiteListURL.host ||
			url.absoluteString.starts(with: whiteListURL.absoluteString) {
			return true
		}
		
		return false
	}
	
	func isBlacklisted(_ url: URL) -> Bool {
		let blackList = getURLList(for: .blacklistURLS)
		return blackList.contains(url)
	}
}



//// MARK: - Private methods and properties
private extension FirebaseConfig {
	func getURLList(for key: RemoteConfigKey) -> [URL] {
		guard let remoteConfigValue = remoteConfig.configValue(forKey: key).stringValue, !remoteConfigValue.isEmpty else {
			print("No remote config value found for '\(key)', or it is empty")
			return []
		}
		
		let decoder = JSONDecoder()
		let data = Data(remoteConfigValue.utf8)

		do {
			let urlStrings = try decoder.decode([String].self, from: data)
			let urlList = urlStrings.compactMap { URL(string: $0) }
			return urlList
		} catch {
			print("\(error)")
			return []
		}
	}
}

