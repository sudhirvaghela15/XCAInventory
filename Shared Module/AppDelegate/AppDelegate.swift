//
//  AppDelegate.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		
		FirebaseApp.configure()
		/// uncommnent this below funciton call if you going to use local firebase emulator
		setupFirebaseLocalEmulator()
		
		return true
	}
	
	private func setupFirebaseLocalEmulator() {
		/// port are used same as set in firebase local project json
		var host = cprint("127.0.0.1")
		#if !targetEnvironment(simulator)
		host = "172.20.10.4" /// settings -> wifi -> ip adresss and make sure wirewall is disabled
		#endif
		let storage = Storage.storage()
		storage.useEmulator(withHost: host, port: 9198)
		
		let settings = Firestore.firestore().settings
		settings.isSSLEnabled = false /// ⚠️ Important: disable SSL for emulator
		settings.host = host+":8081"
		settings.cacheSettings = MemoryCacheSettings()
		Firestore.firestore().settings = settings
	}
}
