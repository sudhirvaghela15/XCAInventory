//
//  Helper.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import Foundation

@discardableResult
func cprint<T>(value: T, label: String = "DebugValue") -> T {
	debugPrint("\(label): \(value)")
	return value
}
