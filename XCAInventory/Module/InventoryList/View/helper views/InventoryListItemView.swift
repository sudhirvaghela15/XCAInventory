//
//  InventoryListItemView.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import SwiftUI

struct InventoryListItemView: View {
	
	let model: InventoryItem
	
	var body: some View {
		HStack(alignment: .top, spacing: 16) {
			
			ZStack {
				RoundedRectangle(cornerRadius: 16)
					.foregroundStyle(.gray.opacity(0.3))
				
				if let thumbnailURL = model.thumbnailURL {
					AsyncImage(url: thumbnailURL) { reuslt in
						switch reuslt {
						case .success(let image):
							image.resizable()
							image.aspectRatio(contentMode: .fit)
						default: ProgressView()
						}
					}
				}
			}
			.overlay(content: {
				RoundedRectangle(cornerRadius: 16)
					.stroke(.gray.opacity(0.5), lineWidth: 1)
			})
			.frame(width: 150, height: 150)
			
			VStack(alignment: .leading) {
				Text(model.name)
					.font(.headline)
				Text("Queantity: \(model.quantity)")
					.font(.subheadline)
			}
		}
	}
}
