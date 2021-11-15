//
//  File.swift
//  
//
//  Created by Benjamin Böcker on 03.08.21.
//

import Foundation
import Inject

func dependencyInjection(with config: AppConfig) {
	Container.default.register {
		Registration(config)
		Registration(LoginMessageHandler() as MessageHandler)
		Registration(NotificationManagerComponent() as NotificationManager)
		Registration(SettingsMessageHandler() as MessageHandler)
	}
}
