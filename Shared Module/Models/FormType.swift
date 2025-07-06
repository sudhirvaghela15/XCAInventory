//
//  FormType.swift
//  XCAInventory
//
//  Created by sudhir on 06/07/25.
//

import Foundation

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
