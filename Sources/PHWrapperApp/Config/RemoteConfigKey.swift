//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 28.07.21.
//

import Foundation


typealias RemoteConfigKey = String

extension RemoteConfigKey {
	static let sideMenuItems: Self = "nav_items"
	static let startPath: Self = "start_path"
	//	static let domain: Self = "domain"
	static let startURL: Self = "start_url"
	static let whitelist: Self = "whitelist"
	static let navItems: Self = "nav_items"
	static let loginURL: Self = "login_url"
	static let logoutURL: Self = "logout_url"
	static let searchURL: Self = "search_url"
	static let profileURL: Self = "profile_url"
	static let blacklistURLS: Self = "blacklist_urls"
	static let registerURL: Self = "register_url"
	static let donateURL: Self = "donate_url"
	static let communityURL: Self = "community_url"
	static let twitterURL: Self = "twitter_url"
	static let facebookURL: Self = "facebook_url"
}
