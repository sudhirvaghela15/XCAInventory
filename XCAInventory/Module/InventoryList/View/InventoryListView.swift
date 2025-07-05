//
//  InventoryListView.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import SwiftUI

struct InventoryListView: View {
	
	@StateObject var viewModel: InventoryListViewModel = .init()
	
    var body: some View {
		List {
			ForEach(viewModel.inventoryItems) { model in
				InventoryListItemView(model: model)
			}
		}
		.navigationTitle("XCA AR Inventory")
		.onAppear {
			viewModel.fetchInventoryItems()
		}
    }
}

struct InventoryListItemView: View {
	
	let model: InventoryItem
	
	var body: some View {
		Text(model.name)
	}
}

#Preview {
    InventoryListView()
}
