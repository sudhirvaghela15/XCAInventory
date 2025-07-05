//
//  InventoryListView.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import SwiftUI

struct InventoryListView: View {
	
	@StateObject var viewModel: InventoryListViewModel = .init()
	
	@State var formType: FormType?
	
    var body: some View {
		List {
			ForEach(viewModel.inventoryItems) { model in
				InventoryListItemView(model: model)
					.listRowSeparator(.hidden)
					.contentShape(Rectangle())
					.onTapGesture {
						formType = .edit(model)
					}
					
			}
		}
		.navigationTitle("XCA AR Inventory")
		.onAppear {
			viewModel.fetchInventoryItems()
		}
    }
}

#Preview {
	NavigationStack {
		InventoryListView()
	}
}
