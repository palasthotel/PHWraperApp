//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 13.05.24.
//

import Foundation



enum DeviceID { }


extension DeviceID {
	static var id: String? {
		get {
			UserDefaults.standard.string(for: "ph-wrapper-app.device-id")
		}
		set {			
			UserDefaults.standard.setValue(newValue, forKey: "ph-wrapper-app.device-id")
		}
	}
}
