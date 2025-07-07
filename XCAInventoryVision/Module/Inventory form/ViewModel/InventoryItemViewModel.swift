//
//  InventoryItemViewModel.swift
//  XCAInventoryVision
//
//  Created by sudhir on 07/07/25.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import SwiftUI
import RealityKit

class InventoryItemViewModel: ObservableObject {
	@Published
	var model: InventoryItem?
	
	@Published
	var usdzFileURL: URL?
	
	@Published
	var entity: ModelEntity?
	
	var onItemDeleted: (() -> Void)? = nil
	
	func listenToItem(_ model: InventoryItem) {
		self.model = model
		
		Firestore.firestore()
			.collection("items")
			.document(model.id)
			.addSnapshotListener { snapshot, error in
				guard let snapshot else {
					print("Error fetching snapshot \(error?.localizedDescription ?? "error")")
					return
				}
				if !snapshot.exists { // if item is deleted
					self.onItemDeleted?()
					return
				}
				
				self.model = try? snapshot.data(as: InventoryItem.self)
				
				if let usdzURL =  model.usdzURL {
					Task {
						await self.fetchFileURL(usdzURL: usdzURL)
					}
				} else {
					self.entity = nil
					self.usdzFileURL = nil
				}
			}
	}
	
	@MainActor
	func fetchFileURL(usdzURL: URL) async {
		guard let url = usdzURL.usdzFileCacheURL else { return }
		
		if let usdzFileURL, usdzFileURL.lastPathComponent ==  url.lastPathComponent {
			return
		}
		
		do {
			if !FileManager.default
				.fileExists(atPath: url.absoluteString) {
				_ = try await Storage
					.storage()
					.reference(forURL: usdzURL.absoluteString)
					.writeAsync(toFile: url)
				
				let entity = try await ModelEntity(contentsOf: url)
				entity.name = model?.usdzURL?.absoluteString ?? ""
				entity.generateCollisionShapes(recursive: true)
				entity.components.set(InputTargetComponent())
				self.usdzFileURL = url
				self.entity = entity
			}
				
		} catch {
			self.entity = nil
			self.usdzFileURL = nil
		}
		
	}
}
