//
//  URL+Extension.swift
//  XCAInventoryVision
//
//  Created by sudhir on 07/07/25.
//

import Foundation

extension URL {
	var usdzFileCacheURL: URL? {
		guard let urlcomp = URLComponents(url: self, resolvingAgainstBaseURL: false),
			  let cacheDirURL = FileManager.default.urls(
				for: .cachesDirectory,
				in: .userDomainMask
			  ).first else {
			return nil
		}
		
		let token = urlcomp.queryItems?.first(where:{ $0.name == "token" })?.value ?? UUID().uuidString
		
		let fileCacheURL = cacheDirURL.appending(
			path: "\(token)_\(lastPathComponent)"
		)
		
		return fileCacheURL
	}
}
