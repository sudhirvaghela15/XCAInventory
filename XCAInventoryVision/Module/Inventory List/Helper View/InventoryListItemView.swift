//
//  InventoryListItemView.swift
//  XCAInventory
//
//  Created by sudhir on 06/07/25.
//

import SwiftUI
import RealityKit

struct InventoryListItemView: View {
	
	let model: InventoryItem
	
	var body: some View {
		Button {
			
		} label: {
			labelView
		}.buttonStyle(.borderless)
		.buttonBorderShape(.roundedRectangle(radius: 20))
	}
	
	var labelView: some View {
		VStack {
			ZStack {
				if let usdzURL = model.usdzURL {
					model3D(from: usdzURL)
				} else {
					noItemAvailableView()
				}
			}
			.frame(width: 160, height: 160)
			.padding(32)
			
			Text(model.name)
			Text("Quantity: \(model.quantity)")
		}
		.frame(width: 240, height: 240)
		.padding(32)
	}
	
	func noItemAvailableView() -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 16)
				.foregroundStyle(.gray.opacity(0.3))
			Text("Not Available")
		}
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
