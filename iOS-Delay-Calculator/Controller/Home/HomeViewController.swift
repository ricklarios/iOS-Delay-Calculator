//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Rick Larios on 26/6/22.
//

import UIKit

final class HomeViewController: UIViewController {
	
	// MARK: - Outlets
	
	// Labels
	// Result Label
	@IBOutlet weak var resultLabel: UILabel!
	// Temperature Label
	@IBOutlet weak var temperatureLabel: UILabel!
	// Speed of Sound Label
	@IBOutlet weak var staticSpeedLabel: UILabel!
	@IBOutlet weak var speedLabel: UILabel!
	
	// Slider
	@IBOutlet weak var temperatureSlider: UISlider!
	
	// Segmented Control
	@IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
		
	// Numbers buttons
	@IBOutlet weak var number0: UIButton!
	@IBOutlet weak var number1: UIButton!
	@IBOutlet weak var number2: UIButton!
	@IBOutlet weak var number3: UIButton!
	@IBOutlet weak var number4: UIButton!
	@IBOutlet weak var number5: UIButton!
	@IBOutlet weak var number6: UIButton!
	@IBOutlet weak var number7: UIButton!
	@IBOutlet weak var number8: UIButton!
	@IBOutlet weak var number9: UIButton!
	@IBOutlet weak var numberDecimal: UIButton!
	// Operators
	@IBOutlet weak var operatorAC: UIButton!
	@IBOutlet weak var operatorPlusMinus: UIButton!
	@IBOutlet weak var operatorConvert: UIButton!
	@IBOutlet weak var operatorDivision: UIButton!
	@IBOutlet weak var operatorMultiplication: UIButton!
	@IBOutlet weak var operatorSubstraction: UIButton!
	@IBOutlet weak var operatorAddition: UIButton!
	@IBOutlet weak var operatorResult: UIButton!
	
	// MARK: - Variables
	
	private var total: Double = 0
	private var inputValue: Double = 0
	private var tempValue: Double = 0
	private var operating = false
	private var decimal = false
	private var operation: OperationType = .none
	private var mainUnit: MainUnitType = .meters
	private var speedOfSound: Double = SpeedOfSound(selectedTemp: selectedTemp)
	public var currentSliderRColor = TempColorValue(selectedTemp: selectedTemp)
	
	
	// MARK: - Constantes
	
	private let kDecimalSeparator = Locale.current.decimalSeparator!
	private let kMaxLength = 9
	private let kTotal = "total"
	private let unitsSGArray: Array<String> = ["meters", "seconds"]
	private enum OperationType {
		case none, addition, substraction, multiplication, division
	}
	private enum MainUnitType: String {
		case meters = "meters", seconds = "seconds"
	}
	
	// MARK: - Initialization
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		
		numberDecimal.setTitle(kDecimalSeparator, for: .normal)
		total = UserDefaults.standard.double(forKey: kTotal)
		result()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// UI
		
		// Slider
		temperatureSlider.minimumValue = -55
		temperatureSlider.maximumValue = 55
		temperatureSlider.value = Float(selectedTemp)
		temperatureSlider.minimumTrackTintColor = UIColor.SetVariableColor(r: currentSliderRColor, g: 0, b: 167, alpha: 1)
		
		// Labels
		staticSpeedLabel.text = "Vs = "
		speedLabel.text = "\(round(speedOfSound * 100) / 100) m/s"
		speedLabel.textColor = UIColor.SetVariableColor(r: currentSliderRColor, g: 0, b: 167, alpha: 1)
		
		// Segmented Controls
		unitsSegmentedControl.removeAllSegments()
		
		for (index, value) in unitsSGArray.enumerated() {
			unitsSegmentedControl.insertSegment(withTitle: value, at: index, animated: true)
		}
		unitsSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for:  .normal)
		unitsSegmentedControl.selectedSegmentIndex = unitsSGArray.firstIndex(of: mainUnit.rawValue)!
		if #available(iOS 13.0, *) {
			unitsSegmentedControl.selectedSegmentTintColor = metersColor
		} else {
			// Fallback on earlier versions
		}
		
		
		// Buttons
		number0.round()
		number1.round()
		number2.round()
		number3.round()
		number4.round()
		number5.round()
		number6.round()
		number7.round()
		number8.round()
		number9.round()
		numberDecimal.round()
		
		operatorAC.round()
		operatorPlusMinus.round()
		operatorConvert.round()
		operatorDivision.round()
		operatorMultiplication.round()
		operatorSubstraction.round()
		operatorAddition.round()
		operatorResult.round()
		
		
		
	}

	// MARK: - Slider Action
	@IBAction func tempSliderAction(_ sender: Any) {
		
		// Formateamos los valores del slider y los mostramos en la label
		let step: Double = 0.1
		var myTempSlideValue: Double = Double(round(Double(temperatureSlider.value) / step) * step  )
		myTempSlideValue = round(myTempSlideValue * 10) / 10
		temperatureLabel.text = "\(myTempSlideValue) ºC"
		
		// Calculamos la Vs en base a la temperatura seleccionada
		selectedTemp = myTempSlideValue
		let currentSpeed = SpeedOfSound(selectedTemp: selectedTemp)
		speedLabel.text = "\(round(currentSpeed * 100) / 100) m/s"
		
		// Variamos color slider y Vs en función de la temperatura
		currentSliderRColor = TempColorValue(selectedTemp: selectedTemp)
		temperatureSlider.minimumTrackTintColor = UIColor.SetVariableColor(r: currentSliderRColor, g: 0, b: 167, alpha: 1)
			
	}
	
	
	// MARK: - Segmented Control Action
	
	@IBAction func segmentedControlAction(_ sender: Any) {
		convertUnits()
	
	}
	// MARK: - Button Actions
	
	@IBAction func operatorACAction(_ sender: UIButton) {
		
		clear()
		resultLabel.shine()
		sender.shine()
	}
	@IBAction func operatorPlusMinusAction(_ sender: UIButton) {
		if total != 0 {
			total = total * (-1)
			resultLabel.text = printFormatter.string(from: NSNumber(value: total))
		} else {
			inputValue = inputValue == 0 ? 0 : inputValue * (-1)
			resultLabel.text = printFormatter.string(from: NSNumber(value: inputValue))
		}
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorConvertAction(_ sender: UIButton) {
		
		convertUnits()
		sender.shine()
	}
	
	@IBAction func operatorDivisionAction(_ sender: UIButton) {
		
		if operation != .none  {
			result()
		} else if total != 0 {
			tempValue = total
		}
		
		operating = true
		operation = .division
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorMultiplicationAction(_ sender: UIButton) {
		
		if operation != .none  {
			result()
		} else if total != 0 {
			tempValue = total
		}
		
		operating = true
		operation = .multiplication
		
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorSubstractionAction(_ sender: UIButton) {
		
		if operation != .none  {
			result()
		} else if total != 0 {
			tempValue = total
		}
		
		operating = true
		operation = .substraction
		
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorAdditionAction(_ sender: UIButton) {
		
		if operation != .none  {
			result()
		} else if total != 0 {
			tempValue = total
		}
		
		operating = true
		operation = .addition
		
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorResultAction(_ sender: UIButton) {
		
		resultLabel.shine()
		result()		
		sender.shine()
	}
	
	@IBAction func numberDecimalAction(_ sender: UIButton) {
		
		let currentTemp = auxTotalFormatter.string(from: NSNumber(value: inputValue))!
		if !operating && currentTemp.count >= kMaxLength {
			return
		}
		resultLabel.text = resultLabel.text! + kDecimalSeparator
		decimal = true
		sender.shine()
	}
	
	@IBAction func numberAction(_ sender: UIButton) {
				
		operatorAC.setTitle("C", for: .normal)
		var currentTemp = auxTotalFormatter.string(from: NSNumber(value: inputValue))!
		if !operating && currentTemp.count >= kMaxLength {
			return
		}
		currentTemp = auxFormatter.string(from: NSNumber(value: inputValue))!
				
		// Si hemos seleccionado una operación
		if operating {
			tempValue = tempValue == 0 ? inputValue : tempValue
			resultLabel.text = ""
			currentTemp = ""
			operating = false
		}
		
		// Si hemos seleccionado decimal
		if decimal {
			currentTemp = "\(currentTemp)."
			
		}
		
		// Por defecto
		let number = sender.tag
		inputValue = Double(currentTemp + String(number))!
		resultLabel.text = printFormatter.string(from: NSNumber(value: inputValue))
		sender.shine()
	}
	
	// Limpia los valores
	private func clear() {
		operation = .none
		operatorAC.setTitle("AC", for: .normal)
		if inputValue != 0 {
			inputValue = 0
			resultLabel.text = "0"
		} else {
			inputValue = 0
			tempValue = 0
			total = 0
			result()
		}
	}
	
	private func result() {
		
		switch operation {
		case .none:
			break
		case .addition:
			total = tempValue + inputValue
			break
		case .substraction:
			total = tempValue - inputValue
			break
		case .multiplication:
			total = tempValue * inputValue
			break
		case .division:
			total = tempValue / inputValue
			break
		}
		
		// Formateo en pantalla
		resultLabel.text = printFormatter.string(from: NSNumber(value: total))
				
		
		operation = .none
		
		// Para guardar el resultado en memoria
		UserDefaults.standard.set(total, forKey: kTotal)
		
		print("input: \(inputValue)")
		print("temp: \(tempValue)")
		print("TOTAL: \(total)")
		
		
	}
	
	// Alterna el valor de MainUnitType
	private func switchMainUnit() {
		switch mainUnit {
		case .meters:
			mainUnit = .seconds
			break
		case .seconds:
			mainUnit = .meters
			break
		}
	}
	// Convert units function
	
	private func convertUnits() {
		speedOfSound = SpeedOfSound(selectedTemp: selectedTemp)
		if total != 0 { inputValue = total }
		
		switch mainUnit {
			
			// Pasamos a SECONDS
			case .meters:
				total = inputValue / speedOfSound
				if #available(iOS 13.0, *) {
					unitsSegmentedControl.selectedSegmentTintColor = secondsColor
				}
				break
			
			// Pasamos a METERS
			case .seconds:
				total = inputValue * speedOfSound
				if #available(iOS 13.0, *) {
					unitsSegmentedControl.selectedSegmentTintColor = metersColor
				}
				break
		}
		resultLabel.text = printFormatter.string(from: NSNumber(value: total))
				
		switchMainUnit()
		unitsSegmentedControl.selectedSegmentIndex = unitsSGArray.firstIndex(of: mainUnit.rawValue) ?? 0
				
	}
}
