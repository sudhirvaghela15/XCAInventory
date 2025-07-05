//
//  InventoryFormViewModel.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import QuickLookThumbnailing

final class InventoryFormViewModel: ObservableObject {
	let db = Firestore.firestore()
	let formType: FormType
	let id: String
	
	@Published
	var name: String = ""
	
	@Published
	var quantity: Int = 0
	
	@Published
	var usdzURL: URL?
	
	@Published
	var thumbnailURL: URL?
	
	@Published
	var loadingState: LoadingType = .none
	
	@Published
	var error: Error?
	
	var navigationTitle: String {
		switch formType {
			case .add:
				return "Add Item"
			case .edit:
				return "Edit Item"
		}
	}
	
	init(formType: FormType = .add) {
		self.formType = formType
		switch formType {
			case .add:
				id = UUID().uuidString
			case .edit(let item):
			id = item.id
			name = item.name
			quantity = item.quantity
			
			if let url = item.usdzURL {
				self.usdzURL = url
			}
			
			if let url = item.thumbnailURL {
				self.thumbnailURL = url
			}
		}
	}
	
	func save() throws {
		loadingState = .savingItem
		
		defer { loadingState = .none }
		
		var item: InventoryItem
		
		switch formType {
		case .add:
			item = .init(id: id, name: name, quantity: quantity)
			
		case .edit(let inventoryItem):
			item = inventoryItem
			item.name = name
			item.quantity = quantity
		}
		
		item.usdzLink = usdzURL?.absoluteString
		item.thumbnailLink = thumbnailURL?.absoluteString
		
		do {
			try db.document("items/\(item.id)")
				.setData(from: item, merge: true)
		} catch {
			self.error = error.localizedDescription
			throw error
		}
	}
}


enum USDZSourceType {
	case fileImported
	case objectCaptured
}

enum UploadType: Equatable {
	case usdz, thnumbnail
}

enum LoadingType: Equatable {
	case none
	case savingItem
	case uploading(UploadType)
}

enum FormType: Identifiable {
	case add
	case edit(InventoryItem)
	
	var id: String {
		switch self {
		case .add:
			return "add"
		case .edit(let inventoryItem):
			return "edit\(inventoryItem.id)"
		}
	}
}
