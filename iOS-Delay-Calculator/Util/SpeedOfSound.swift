//
//  SpeedOfSound.swift
//  iOS-Delay-Calculator
//
//  Created by Rick Larios on 28/6/22.
//

import Foundation

func SpeedOfSound (_ temp: Double) -> Double  {
	
	let temp: Double = temp
	let speedOfSound = 331.4 + (0.61*temp)
	return speedOfSound
}

