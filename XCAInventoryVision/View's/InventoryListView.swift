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
		LazyVGrid(columns: gridItems) {
			Text("Placemark")
			Text("Placemark")
			Text("Placemark")
		}
	}
}

#Preview {
	InventoryListView()
}
