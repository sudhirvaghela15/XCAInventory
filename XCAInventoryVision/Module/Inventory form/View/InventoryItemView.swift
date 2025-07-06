//
//  InventoryItemView.swift
//  XCAInventoryVision
//
//  Created by sudhir on 07/07/25.
//

import SwiftUI

struct InventoryItemView: View {
	
	@StateObject
	var viewModel: InventoryItemViewModel = .init()
	
	@EnvironmentObject
	var navigationViewModel: NavigationViewModel
	
	@Environment(\.dismiss)
	var dismiss
	
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    InventoryItemView()
}
