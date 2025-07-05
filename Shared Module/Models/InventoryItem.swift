//
//  InventoryItem.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import FirebaseFirestore
import Foundation

struct InventoryItem: Identifiable, Codable, Equatable {
	
	var id = UUID().uuidString
	
	@ServerTimestamp
	var createAt: Date?
	
	@ServerTimestamp
	var updateAt: Date?
	
	var name: String
	var qunatity: Int
	
	var usdzLink: String?
	var usdzURL: URL? {
		guard let usdzLink else { return nil }
		return URL(string: usdzLink)
	}
	
	var thumbnailLink: String?
	var thumbnailURL: URL? {
		guard let thumbnailLink else { return nil }
		return URL(string: thumbnailLink)
	}
}
