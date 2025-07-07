//
//  InventoryItemView.swift
//  XCAInventoryVision
//
//  Created by sudhir on 07/07/25.
//

import SwiftUI
import RealityKit

struct InventoryItemView: View {
	
	@StateObject
	var viewModel: InventoryItemViewModel = .init()
	
	@EnvironmentObject
	var navigationViewModel: NavigationViewModel
	
	@Environment(\.dismiss)
	var dismiss
	
    var body: some View {
		ZStack(alignment: .bottom) {
			RealityView { rvContent in
			 
			} update: { rvContent in
				if viewModel.entity == nil && !rvContent.entities.isEmpty {
					rvContent.entities.removeAll()
				}
				
				if let entity = viewModel.entity {
					if let currentEntity = rvContent.entities.first, entity == currentEntity {
						return
					}
					
					rvContent.entities.removeAll()
					rvContent.add(entity)
				}
			}
			
			VStack {
				Text(viewModel.model?.name ?? "")
				Text("Quantity: \(viewModel.model?.quantity ?? 0)")
			}.padding(32)
			.clipShape(RoundedRectangle(cornerRadius: 16))
			.background(.ultraThinMaterial)
			.font(.extraLargeTitle)
			.zIndex(1)
			
		}.onAppear() {
			guard let item = navigationViewModel.selectedItem else {
				return
			}
			viewModel.onItemDeleted = { dismiss() }
			viewModel.listenToItem(item)
		}
    }
}

#Preview {
    InventoryItemView()
}
