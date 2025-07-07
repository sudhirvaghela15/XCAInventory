//
//  InventoryListView.swift
//  XCAInventoryVision
//
//  Created by sudhir on 06/07/25.
//

import SwiftUI

struct InventoryListView: View {
	
	@StateObject
	var viewModel: InventoryListViewModel = .init()
	
	private let gridItems: [GridItem] = [
		.init(.adaptive(minimum: 240), spacing: 16)
	]
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: gridItems) {
				ForEach(viewModel.inventoryItems) { model in
					InventoryListItemView(model: model)
						.onDrag {
							guard let usdzURL = model.usdzURL else  {
								return NSItemProvider()
							}
							
							return NSItemProvider(
								object: USDZItemProvider(usdzURL: usdzURL)
							)
						}
				}
			}
			.padding(.vertical)
			.padding(.horizontal, 30)
		}
		.navigationTitle("XCA AR Inventory")
		.onAppear(
			perform: viewModel.addInventoryListener
		)
	}
}

#Preview {
	InventoryListView()
}
