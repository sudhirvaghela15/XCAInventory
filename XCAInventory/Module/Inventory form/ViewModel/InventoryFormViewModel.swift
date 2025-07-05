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
	
	@Published
	var uploadProgress: UploadProgress?
	
	@Published
	var showUSDZSource: Bool = false
	
	@Published
	var selectedUSDZSourceTypee: USDZSourceType?
	
	let byteCountFormatter: ByteCountFormatter = {
		let f = ByteCountFormatter()
		f.countStyle = .file
		return f
	}()
	
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
	
	@MainActor
	func usdzDelete() async {
		let storageRef = Storage.storage().reference()
	   	let usdzRef = storageRef.child("\(id).usdz")
	   	let thumbnailRef = storageRef.child("\(id).jpg")
		
		loadingState = .delete(.usdzWithThumbnail)
		
		defer { loadingState = .none }
		
		do {
			try await usdzRef.delete()
			try? await thumbnailRef.delete()
			self.usdzURL = nil
			self.thumbnailURL = nil
		} catch {
			self.error = error.localizedDescription
		}
	}
	
	@MainActor
	func deleteItem() async throws {
		loadingState = .delete(.item)
		do {
			try await db.document("items/\(id)").delete()
			try? await Storage.storage().reference().child("\(id).usdz").delete()
			try? await Storage.storage().reference().child("\(id).jpg").delete()
		} catch {
			loadingState = .none
			throw error
		}
	}
	
	@MainActor
	func uploadUSDZ(fileURL: URL) async {
		let gotAccess = fileURL.startAccessingSecurityScopedResource()
		
		defer {
			fileURL.stopAccessingSecurityScopedResource()
			loadingState = .none
		}
		
		guard gotAccess, let data = try? Data(contentsOf: fileURL) else {
			return
		}
		
		uploadProgress = .init(
			fractionCompleted: 0,
			totalUnitCount: 0,
			completeUnitCount: 0
		)
		
		loadingState = .uploading(.usdz)
		
		do {
			/// upload USDZ to firebase storage
			let storageRef = Storage.storage().reference()
			let usdzRef = storageRef.child("\(id).usdz")
			let metadata = StorageMetadata(dictionary: ["contentType": "model/vnd.usd+zip"])
			
			_ = try await usdzRef.putDataAsync(data, metadata: metadata) { [weak self] progress in
					guard let self, let progress else { return }
					self.uploadProgress = .init(
						fractionCompleted: progress.fractionCompleted,
						totalUnitCount: progress.totalUnitCount,
						completeUnitCount: progress.completedUnitCount
					)
				}
			
			let downloadURL = try await usdzRef.downloadURL()
			
			/// generate thumbnail
			let cacheDirURL = FileManager.default.urls(
				for: .cachesDirectory,
				in: .userDomainMask
			).first
			
			if let fileCacheURL = cacheDirURL?.appending(path: "temp_\(id).usdz") {
				
				try? data.write(to: fileCacheURL)
				
				let thumbnailRequest = QLThumbnailGenerator.Request(
					fileAt: fileCacheURL,
					size: CGSize(width: 300, height: 300),
					scale: UIScreen.main.scale,
					representationTypes: .all
				)
				
				let thumbnail = try? await QLThumbnailGenerator.shared.generateBestRepresentation(
					for: thumbnailRequest
				)
				
				if let jpdData = thumbnail?.uiImage.jpegData(compressionQuality: 0.5) {
					loadingState = .uploading(.thumbnail)
					let thumbnailRef = storageRef.child("\(id).jpg")
					
					_ = try? await thumbnailRef.putDataAsync(
						jpdData,
						metadata: .init(dictionary: ["contentType": "image/jpeg"]),
						onProgress: { [weak self] progress in
							guard let self, let progress else { return }
							self.uploadProgress = .init(
								fractionCompleted: progress.fractionCompleted,
								totalUnitCount: progress.totalUnitCount,
								completeUnitCount: progress.completedUnitCount
							)
						}
					)
					
					if let thumbnailURL = try? await thumbnailRef.downloadURL() {
						self.thumbnailURL = thumbnailURL
					}
				}
			}
			
			self.usdzURL = downloadURL
			
		} catch {
			self.error = error.localizedDescription
		}
	}
}


struct UploadProgress {
	var fractionCompleted: Double
	var totalUnitCount: Int64
	var completeUnitCount: Int64
}

enum USDZSourceType {
	case fileImported
	case objectCaptured
}

enum UploadType: Equatable {
	case usdz, thumbnail
}

enum DeleteType {
	case usdzWithThumbnail
	case item
}

enum LoadingType: Equatable {
	case none
	case savingItem
	case uploading(UploadType)
	case delete(DeleteType)
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
