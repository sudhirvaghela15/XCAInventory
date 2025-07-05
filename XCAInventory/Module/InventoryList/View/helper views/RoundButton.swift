//
//  RoundButton.swift
//  XCAInventory
//
//  Created by sudhir on 06/07/25.
//

import SwiftUI

struct RoundButton: View {
	let action: () -> Void
	let image: Image
	
	var body: some View {
		Button(action: action) {
			image
			   .font(.headline)
			   .foregroundColor(.white)
			   .padding(5)
			   .frame(maxWidth: .infinity)
			   .background(Color.blue)
			   .clipShape(.circle)
			   .shadow(color: .black.opacity(0.4), radius: 8, x: 3, y: 3)
			   .padding(.horizontal, 5)
		}
	}
}
