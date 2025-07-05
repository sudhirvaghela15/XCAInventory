//
//  InventoryFormView.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct InventoryFormView: View {
	
	@StateObject var viewModel: InventoryFormViewModel = .init()
	
	@Environment(\.dismiss) var dismiss
	
    var body: some View {
		
		let isPresentedFileImporter = Binding(
		   get: {
			   viewModel.selectedUSDZSourceTypee == .fileImported
		   }, set: { _ in
				 viewModel.selectedUSDZSourceTypee = nil
		   }
	   )
		
		Form {
			List {
				inputSection
			}
		}.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				
				RoundButton(
					action: { dismiss() },
					image: Image(systemName: "xmark")
				).disabled(viewModel.loadingState != .none)
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
		}
		.confirmationDialog(
			"Add USDZ",
			isPresented: $viewModel.showUSDZSource,
			titleVisibility: .visible,
			actions: {
				Button("Select file") {
					viewModel.selectedUSDZSourceTypee = .fileImported
				}
				
				Button("Object Capture") {
					viewModel.selectedUSDZSourceTypee = .objectCaptured
				}
			}
		)
		.fileImporter(isPresented: isPresentedFileImporter,
			allowedContentTypes: [UTType.usdz],
			onCompletion: { result in
				switch result {
				case .success(let url):
					Task {
						await viewModel.uploadUSDZ(fileURL: url)
					}
				case .failure(let failure):
					viewModel.error = failure.localizedDescription
				}
			}
		)
		.alert(
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
