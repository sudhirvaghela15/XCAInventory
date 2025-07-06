//
//  InventoryListView.swift
//  XCAInventoryVision
//
//  Created by sudhir on 06/07/25.
//

import SwiftUI
import RealityKit

struct InventoryListView: View {
	
	@StateObject var viewModel: InventoryListViewModel = .init()
	
	private let gridItems: [GridItem] = [
		.init(.adaptive(minimum: 240), spacing: 16)
	]
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: gridItems) {
				ForEach(viewModel.inventoryItems) { model in
					InventoryListItemView(model: model)
				}
			}
			.padding(.vertical)
			.padding(.horizontal, 30)
		}
		.navigationTitle("XCA AR Inventory")
		.onAppear(perform: viewModel.addInventoryListener)
	}
}

struct InventoryListItemView: View {
	
	let model: InventoryItem
	
	var body: some View {
		Button {
			
		} label: {
			VStack {
				
				ZStack {
					if let usdzURL = model.usdzURL {
						model3D(from: usdzURL)
					} else {
						RoundedRectangle(cornerRadius: 16)
							.foregroundStyle(.gray.opacity(0.3))
						Text("Not Available")
					}
				}
				.frame(width: 160, height: 160)
				.padding(32)
				
				Text(model.name)
				Text("Quantity: \(model.quantity)")
			}
			.frame(width: 240, height: 240)
			.padding(32)
		}.buttonStyle(.borderless)
		.buttonBorderShape(.roundedRectangle(radius: 20))
	}
	
	func model3D(from usdzURL: URL) -> some View {
		Model3D(url: usdzURL) { result in
			switch result {
				case .success(let model3D):
					model3D.aspectRatio(contentMode: .fit)
				case .failure:
					Text("Failed to dawnload 3d Model")
				default: ProgressView()
			}
		}
	}
}

#Preview {
	InventoryListView()
}
