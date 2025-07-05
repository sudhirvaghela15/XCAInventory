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
		.toolbar(content: {
			ToolbarItem(placement: .primaryAction) {
				Button(action: {
					formType = .add
				}) {
				   Image(systemName: "plus")
					   .font(.headline)
					   .foregroundColor(.white)
					   .padding(5)
					   .frame(maxWidth: .infinity)
					   .background(Color.blue)
					   .clipShape(.circle)
					   .shadow(color: .black.opacity(0.4), radius: 8, x: 3, y: 3)
					   .padding(.horizontal, 5)
				}
			}
		})
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
