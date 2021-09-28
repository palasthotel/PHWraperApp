//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 03.08.21.
//

import Foundation


extension UserDefaults {
	func set<T>(_ value: T, for key: Key) {
		let key = key.value
		set(value, forKey: key)
	}
	
	func get<T>(valueFor key: Key) -> T {
		let key = key.value
		return value(forKey: key) as! T
	}
	
	func string(for key: Key) -> String? {
		let key = key.value
		return value(forKey: key) as? String
	}
	
	func register(keyedDefaults defaults: [Key: Any]) {
		let keys = defaults.keys.map { $0.value }
		let values = defaults.values.map { value in
			value
		}
				
		let zippedDefaults = Dictionary(uniqueKeysWithValues: zip(keys, values))

		UserDefaults.standard.register(defaults: zippedDefaults)
	}
}



extension UserDefaults {
	struct Key: ExpressibleByStringLiteral, Hashable {
		let value: String
		
		init(stringLiteral value: StringLiteralType) {
			self.value = value
		}
	}
}
