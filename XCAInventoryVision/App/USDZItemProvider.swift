//
//  USDZItemProvider.swift
//  XCAInventoryVision
//
//  Created by sudhir on 07/07/25.
//


import Foundation
import FirebaseStorage
import UniformTypeIdentifiers

class USDZItemProvider: NSObject, Codable, NSItemProviderWriting {
	
	let usdzURL: URL
	
	init(usdzURL: URL) {
		self.usdzURL = usdzURL
	}
	
	static var writableTypeIdentifiersForItemProvider: [String] {
		[UTType.usdz.identifier]
	}
	
	func loadData(withTypeIdentifier typeIdentifier: String,
				  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
		
		guard let fileCachedURL = usdzURL.usdzFileCacheURL else {
			completionHandler(nil, NSError(domain: "USDZItemProvider", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cached file URL not found."]))
			return nil
		}
		
		if let data = try? Data(contentsOf: fileCachedURL) {
			completionHandler(data, nil)
		} else {
			Storage.storage()
				.reference(forURL: usdzURL.absoluteString)
				.write(toFile: fileCachedURL) { result in
					switch result {
					case .success(let url):
						guard let data = try? Data(contentsOf: url) else {
							completionHandler(nil, NSError(domain: "USDZItemProvider", code: 2, userInfo: [NSLocalizedDescriptionKey: "Downloaded file not found."]))
							return
						}
						completionHandler(data, nil)
					case .failure(let error):
						completionHandler(nil, error)
					}
				}
		}
		
		return nil
	}
}
