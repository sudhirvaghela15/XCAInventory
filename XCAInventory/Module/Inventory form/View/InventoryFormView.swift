//
//  InventoryFormView.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import SwiftUI

struct InventoryFormView: View {
	
	@StateObject var viewModel: InventoryFormViewModel = .init()
	
	@Environment(\.dismiss) var dismiss
	
    var body: some View {
		Form {
			List {
				inputSection
			}
		}.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel") {
					dismiss()
				}.disabled(viewModel.loadingState != .none)
			}
			
			
			ToolbarItem(placement: .confirmationAction) {
				Button("Save") {
					do {
						try viewModel.save()
						dismiss()
					} catch {
						
					}
				}.disabled(
					viewModel.loadingState != .none || viewModel.name
						.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
				)
			}
		}.alert(
			isPresented: .constant(viewModel.error != nil),
			error: "An Error Occured",
			actions: { _ in },
			message: { _ in
				Text(viewModel.error.debugDescription)
			}
		)
		.navigationTitle(viewModel.navigationTitle)
		.navigationBarTitleDisplayMode(.inline)
    }
	
	var inputSection: some View {
		Section {
			TextField("Name", text: $viewModel.name)
			Stepper("Quantity \(viewModel.quantity)", value: $viewModel.quantity)
		}.disabled(viewModel.loadingState != .none)
	}
}

#Preview {
	NavigationStack {
		InventoryFormView()
	}
}
