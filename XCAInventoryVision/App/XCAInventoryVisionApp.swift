//
//  XCAInventoryVisionApp.swift
//  XCAInventoryVision
//
//  Created by sudhir on 05/07/25.
//

import SwiftUI

@main
struct XCAInventoryVisionApp: App {
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject var navigationViewModel: NavigationViewModel = .init()
	
    var body: some Scene {
        WindowGroup {
			NavigationStack {
				InventoryListView()
					.environmentObject(navigationViewModel)
			}
        }
		
		WindowGroup(id: "item") {
			InventoryItemView()
				.environmentObject(navigationViewModel)
		}
		.windowStyle(.volumetric)
		.defaultSize(width: 1, height: 1, depth: 1, in: .meters)
    }
}
