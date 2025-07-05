//
//  UIApplication+Extension.swift
//  XCAInventory
//
//  Created by sudhir on 06/07/25.
//

import UIKit

extension UIApplication {
	var firstKeyWindow: UIWindow? {
		UIApplication
			.shared
			.connectedScenes
			.compactMap {
				$0 as? UIWindowScene
			}.filter(
				{ $0.activationState == .foregroundActive }
			).first?.keyWindow
	}
}
