//
//  Formatters.swift
//  iOS-Delay-Calculator
//
//  Created by Rick Larios on 29/6/22.
//

import Foundation

// Formateo de valores auxiliares
	public let auxFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		let locale = Locale.current
		formatter.groupingSeparator = ""
		formatter.decimalSeparator = locale.decimalSeparator
		formatter.numberStyle = .decimal
		formatter.maximumIntegerDigits = 100
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = 100
		return formatter
	}()
// Formateo de valores auxiliares totales
public let auxTotalFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.groupingSeparator = ""
		formatter.decimalSeparator = ""
		formatter.numberStyle = .decimal
		formatter.maximumIntegerDigits = 100
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = 100
		return formatter
	}()
// Formateo de valores por pantalla por defecto
public let printFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		let locale = Locale.current
		formatter.groupingSeparator = locale.groupingSeparator
		formatter.decimalSeparator = locale.decimalSeparator
		formatter.numberStyle = .decimal
		formatter.maximumIntegerDigits = 9
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = 8
		return formatter
	}()
// Formateo de valores por pantalla en formato científico
public let printScientificFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .scientific
		formatter.maximumFractionDigits = 3
		formatter.exponentSymbol = "e"
		return formatter
	}()
