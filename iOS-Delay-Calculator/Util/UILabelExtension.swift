//
//  UILabelExtension.swift
//  iOS-Delay-Calculator
//
//  Created by Rick Larios on 30/6/22.
//

import UIKit

extension UILabel {
	
	// Brilla
		func shine() {
			UIView.animate(withDuration: 0.03, animations: {
				self.alpha = 0
			}) { (completion) in
				UIView.animate(withDuration: 0.03, animations: {
					self.alpha = 1
				})
			}
		}

}
