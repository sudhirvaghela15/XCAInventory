//
//  InventoryListViewModel.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import FirebaseFirestore
import Foundation
import SwiftUI

class InventoryListViewModel: ObservableObject {
	
	@Published
	var inventoryItems: [InventoryItem] = []
	
	@Published
	var formType: FormType?
	
	@MainActor
	func addInventoryListener() {
		Firestore
			.firestore()
			.collection("items")
			.order(by: "name")
			.limit(toLast: 100)
			.addSnapshotListener { snapshot, error in
				guard let snapshot else {
					cprint(value: error?.localizedDescription)
					return
				}
				
				let docs = snapshot.documents
				let items = docs.compactMap { docSnapshot in
					try? docSnapshot.data(as: InventoryItem.self)
				}
				
				withAnimation {
					self.inventoryItems = items
				}
			}
	}
}
