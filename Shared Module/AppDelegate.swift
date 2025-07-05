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
	func applicationDidFinishLaunching(_ application: UIApplication) {
		FirebaseApp.configure()
		/// uncommnent this below funciton call if you going to use local firebase emulator
		setupFirebaseLocalEmulator()
	}
	
	private func setupFirebaseLocalEmulator() {
		var host = "127.0.0.0"
		#if !targetEnvironment(simulator)
		host = "172.20.10.4"
		#endif
		let settings = Firestore.firestore().settings
		settings.host = host+":8080"
		settings.cacheSettings = MemoryCacheSettings()
		Firestore.firestore().settings = settings
		//
		Storage.storage().useEmulator(withHost: host, port: 9199)
	}
}
