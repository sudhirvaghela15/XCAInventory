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
	
	// 3D ROTATION
	@State
	var angle: Angle = .degrees(0)
	@State
	var startAngle: Angle?
	@State
	var axis: (CGFloat, CGFloat, CGFloat) = (.zero, .zero, .zero)
	@State
	var startAxis: (CGFloat, CGFloat, CGFloat)?
	
	/// Scale Effect
	@State
	var scale: Double = 2
	@State
	var startScale: Double?
	
    var body: some View {
		ZStack(alignment: .bottom) {
			RealityView { _ in }
			update: { rvContent in
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
			.rotation3DEffect(angle, axis: axis)
			.scaleEffect(scale)
			.simultaneousGesture(DragGesture()
				.onChanged({ value in
					if let startAngle, let startAxis {
						let _angle = sqrt(
							pow(value.translation.width, 2) +
							pow(value.translation.height, 2) +
							startAngle.degrees
						)
						let axisX = ((-value.translation.height + startAxis.0) / CGFloat(_angle))
						let axisY = ((value.translation.width + startAxis.1) / CGFloat(_angle))
						angle = Angle(degrees: Double(_angle))
						axis = (axisX, axisY, 0)
					} else {
						startAngle = angle
						startAxis = axis
					}}).onEnded({ value in
						startAngle = angle
						startAxis = axis
					}))
			.simultaneousGesture(MagnifyGesture()
				.onChanged({ value in
					if let startScale {
						scale = max(1, min(3, value.magnification * startScale))
					} else {
						startScale = scale
					}
				}).onEnded({ value in
					
				})
			).zIndex(1)
			
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
