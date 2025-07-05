//
//  String+Extension.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import Foundation

extension String: @retroactive Error, @retroactive LocalizedError {
	public var errorDescription: String? {
		return self
	}
}
