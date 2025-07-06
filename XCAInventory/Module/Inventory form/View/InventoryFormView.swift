//
//  InventoryFormView.swift
//  XCAInventory
//
//  Created by sudhir on 05/07/25.
//

import SwiftUI
import UniformTypeIdentifiers
import SafariServices

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
				arSection
				
				if case let .delete(type) = viewModel.loadingState {
					HStack {
						Spacer()
						VStack(spacing: 10) {
							ProgressView()
							Text("Deleting \(type == .usdzWithThumbnail ? "USDZ file" : "Item")")
								.foregroundStyle(.red )
						}
						Spacer()
					}
				}
				
				if case .edit = viewModel.formType {
					Button("Delete", role: .destructive) {
						Task {
							do {
								try await viewModel.deleteItem()
								dismiss()
							} catch {
								viewModel.error = error.localizedDescription
							}
						}
					}
				}
				
			}
		}.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				RoundButton(
					action: { dismiss() },
					image: Image(systemName: "xmark")
				).disabled(viewModel.loadingState != .none)
			}
			
			ToolbarItem(placement: .confirmationAction) {
				
				RoundButton(action: {
					try? viewModel.save()
					dismiss()
				}, image: Image(systemName: "checkmark"))
				.disabled(
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
	
	var arSection: some View {
		Section("AR Model") {
			if let thumbnailURL = viewModel.thumbnailURL {
				AsyncImage(url: thumbnailURL) { result in
					switch result {
						case .success(let image):
							image.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: .infinity, maxHeight: 300)
						case .failure:
							Text("Failed to fetch thumbnail")
						default: ProgressView()
					}
				}.onTapGesture {
					guard let usdzURL = viewModel.usdzURL else { return }
					viewAR(url: usdzURL)
				}
			}
			
			if let usdzURL = viewModel.usdzURL {
				Button {
					viewAR(url: usdzURL)
				} label: {
					HStack {
						Image(systemName: "arkit")
							.imageScale(.large)
						Text("View")
					}
				}
				
				Button("Delete USDZ", role: .destructive) {
					Task {
						await viewModel.usdzDelete()
					}
				}
			} else {
				Button {
					viewModel.showUSDZSource.toggle()
				} label: {
					HStack {
						Image(systemName: "arkit")
							.imageScale(.large)
						Text("Add USDZ")
					}
				}
			}
			
			if let progress = viewModel.uploadProgress,
				case let .uploading(type) = viewModel.loadingState,
			   progress.totalUnitCount > 0 {
				VStack {
					ProgressView(value: progress.fractionCompleted) {
						Text(
							"Uploading \(type == .usdz ? "USDZ" : "Thumbnail") file \(Int(progress.fractionCompleted * 100))%"
						)
					}
					
					Text(
						"\(viewModel.byteCountFormatter.string(fromByteCount: progress.completeUnitCount)) / \(viewModel.byteCountFormatter.string(fromByteCount: progress.totalUnitCount))"
					)
				}
			}
		}
		.disabled(viewModel.loadingState != .none)
	}
	
	func viewAR(url: URL) {
		let safariVC = SFSafariViewController(url: url)
		let vc = UIApplication.shared.firstKeyWindow?.rootViewController?.presentedViewController ?? UIApplication.shared.firstKeyWindow?.rootViewController
		vc?.present(safariVC, animated: true)
	}
}

#Preview {
	NavigationStack {
		InventoryFormView()
	}
}
