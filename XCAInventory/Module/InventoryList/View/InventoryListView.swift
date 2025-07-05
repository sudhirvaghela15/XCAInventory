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
				RoundButton(action: {
					formType = .add
				}, image: Image(systemName: "plus"))
			}
		})
		.sheet(item: $formType, content: { formType in
			NavigationStack {
				InventoryFormView(viewModel: .init(formType: formType))
			}
			.presentationDetents([.fraction(0.85)])
			.interactiveDismissDisabled()
		})
		.onAppear {
			viewModel.addInventoryListener()
		}
    }
}



#Preview {
	NavigationStack {
		InventoryListView()
	}
}
