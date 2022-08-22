//
//  UIColorHelpers.swift
//  iOS-Delay-Calculator
//
//  Created by Rick Larios on 1/7/22.
//

import UIKit


// Función que asocia el rango de temp de -55 a 55ºC con un valor RGB de 0 a 255
public func TempColorValue (selectedTemp: Double) -> Int {
	let ColorValue: Int = Int((127.5/55)*(selectedTemp) + 127.5)
	return ColorValue
}

// Operators button custom color
public let operatorsColor: UIColor = UIColor(red: 212/255, green: 216/255, blue: 55/255, alpha: 1)

// Colores para meters/seconds
public let metersColor: UIColor = UIColor(red: 97/255, green:164/255, blue: 211/255, alpha: 1)
public let secondsColor: UIColor = UIColor(red: 254/255, green: 148/255, blue: 1/255, alpha: 0.8)



extension UIColor {
	
	class func SetVariableColor(r: Int, g: Int, b: Int, alpha: Int) -> UIColor {
		let varColor: UIColor = UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(alpha))
		return varColor
	}
	
}


