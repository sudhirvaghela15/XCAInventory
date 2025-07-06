//
//  NavigationViewModel.swift
//  XCAInventoryVision
//
//  Created by sudhir on 07/07/25.
//

import Foundation
import SwiftUI

final class NavigationViewModel: ObservableObject {
	@Published
	var selectedItem: InventoryItem?
	
}
