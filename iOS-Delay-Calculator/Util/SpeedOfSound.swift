//
//  SpeedOfSound.swift
//  iOS-Delay-Calculator
//
//  Created by Rick Larios on 28/6/22.
//

import Foundation

public var selectedTemp: Double = 20

public func SpeedOfSound (selectedTemp: Double) -> Double  {
	let speedOfSound: Double
	let temp: Double = selectedTemp
	speedOfSound = 331.4 + (0.61*temp)
	return speedOfSound
}

