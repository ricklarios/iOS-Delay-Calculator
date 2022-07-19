//
//  UIButtonExtension.swift
//  iOS-Calculator
//
//  Created by Rick Larios on 27/6/22.
//

import UIKit

extension UIButton {

	// Borde redondo
		func round() {
			layer.cornerRadius = bounds.height / 10
			clipsToBounds = true
		}
	
	// Brilla
		func shine() {
			UIView.animate(withDuration: 0.1, animations: {
				self.alpha = 0.5
			}) { (completion) in
				UIView.animate(withDuration: 0.1, animations: {
					self.alpha = 1
				})
			}
		}
	

	// Apariencia selección botón de operación
		func selectOperation(_ selected: Bool) {
			backgroundColor = selected ? .white : operatorsColor
			let titleColor = selected ? operatorsColor : .white
			setTitleColor(titleColor, for: .normal)
			
		}
		
}
