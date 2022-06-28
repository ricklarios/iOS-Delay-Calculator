//
//  AppDelegate.swift
//  iOS-Calculator
//
//  Created by Rick Larios on 18/6/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Setup
		setupView()
		
		return true
	}

	
	// MARK: - Private Methods
	
	// En setupView el indicamos nuestra primera vista
	private func setupView() {
		
		// Instanciamos window
		window = UIWindow(frame: UIScreen.main.bounds)
		// Instanciamos nuestro View Controller
		let vc = HomeViewController()
		// Le decimos que nuestra primera vista será nuestro VC
		window?.rootViewController = vc
		window?.makeKeyAndVisible()
		
		
	}
	


}

