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
	// Views
	@IBOutlet weak var selectTempView: UIView!
	@IBOutlet weak var resultView: UIView!
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
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// UI
		
		// View
		selectTempView.layer.cornerRadius = 10
		
		// Slider
		temperatureSlider.minimumValue = -55
		temperatureSlider.maximumValue = 55
		temperatureSlider.value = Float(selectedTemp)
		temperatureSlider.minimumTrackTintColor = UIColor.SetVariableColor(r: currentSliderRColor, g: 0, b: 167, alpha: 1)
		
		// Labels
		resultView.layer.masksToBounds = true
		resultView.layer.cornerRadius = 10
		staticSpeedLabel.text = "Vs = "
		speedLabel.text = "\(round(speedOfSound * 100) / 100) m/s"
		// speedLabel.textColor = UIColor.SetVariableColor(r: currentSliderRColor, g: 0, b: 167, alpha: 1)
		speedLabel.textColor = .white
		
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
		number0.setTitle("0", for: .normal)
		number1.round()
		number1.setTitle("1", for: .normal)
		number2.round()
		number2.setTitle("2", for: .normal)
		number3.round()
		number3.setTitle("3", for: .normal)
		number4.round()
		number4.setTitle("4", for: .normal)
		number5.round()
		number5.setTitle("5", for: .normal)
		number6.round()
		number6.setTitle("6", for: .normal)
		number7.round()
		number7.setTitle("7", for: .normal)
		number8.round()
		number8.setTitle("8", for: .normal)
		number9.round()
		number9.setTitle("9", for: .normal)
		numberDecimal.round()
		numberDecimal.setTitle(kDecimalSeparator, for: .normal)
		operatorAC.round()
		operatorAC.setTitle("AC", for: .normal)
		operatorPlusMinus.round()
		operatorPlusMinus.setTitle("⁺∕₋", for: .normal)
		operatorConvert.round()
		operatorConvert.setTitle("m⇔s", for: .normal)
		operatorDivision.round()
		operatorDivision.setTitle("÷", for: .normal)
		operatorMultiplication.round()
		operatorMultiplication.setTitle("×", for: .normal)
		operatorSubstraction.round()
		operatorSubstraction.setTitle("−", for: .normal)
		operatorAddition.round()
		operatorAddition.setTitle("+", for: .normal)
		operatorResult.round()
		operatorResult.setTitle("=", for: .normal)
		operatorDivision.backgroundColor = operatorsColor
		operatorMultiplication.backgroundColor = operatorsColor
		operatorSubstraction.backgroundColor = operatorsColor
		operatorAddition.backgroundColor = operatorsColor
		operatorResult.backgroundColor = operatorsColor
		
		
		
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
		
		decimal = false
		convertUnits()
		sender.shine()
	}
	
	@IBAction func operatorDivisionAction(_ sender: UIButton) {
		
		if operation != .none  {
			result()
		}
		
		operating = true
		operation = .division
		decimal = false
		
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorMultiplicationAction(_ sender: UIButton) {
		
		if operation != .none  {
			result()
		}
		
		operating = true
		operation = .multiplication
		decimal = false
		
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorSubstractionAction(_ sender: UIButton) {
		
		if operation != .none  {
			result()
		}
		
		operating = true
		operation = .substraction
		decimal = false
		
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorAdditionAction(_ sender: UIButton) {
		
		if operation != .none  {
			result()
		}
		
		operating = true
		operation = .addition
		decimal = false
		
		resultLabel.shine()
		sender.shine()
	}
	
	@IBAction func operatorResultAction(_ sender: UIButton) {
		
		resultLabel.shine()
		result()		
		sender.shine()
	}
	
	@IBAction func numberDecimalAction(_ sender: UIButton) {
		
		let currentTemp = rawFormatter.string(from: NSNumber(value: inputValue))!
		if decimal || (!operating && currentTemp.count >= kMaxLength) {
			return
		}
		
		// Si hemos seleccionado una operación limpiamos pantalla y almacenamos el valor anterior
		if operating {
			tempValue = tempValue == 0 ? inputValue : total
			inputValue = 0
			resultLabel.text = ""
			operating = false
		}
		
		// Si estamos operando
		if operation != .none && inputValue == 0 {
			resultLabel.text = "0" + kDecimalSeparator
			decimal = true
			sender.shine()
			return
		}
	
		resultLabel.text = resultLabel.text! + kDecimalSeparator
		decimal = true
		sender.shine()
	}
	
	@IBAction func numberAction(_ sender: UIButton) {
				
		operatorAC.setTitle("C", for: .normal)
		// Comprobamos q no haya más de 9 dígitos
		let currentTemp = rawFormatter.string(from: NSNumber(value: inputValue))!
		if !operating && currentTemp.count >= kMaxLength {
			return
		}
		// Asignamos un valor por defecto para mostrar en pantalla
		var printableTemp = resultLabel.text == "0" ? "" :
		resultLabel.text?.replacingOccurrences(of: kDecimalSeparator , with: ".")
		print(printableTemp!)
		
		// Recpgemos el numero pulsado
		let number = sender.tag
		
		// Si hemos seleccionado una operación limpiamos pantalla y almacenamos el valor anterior
		if operating {
			tempValue = tempValue == 0 ? inputValue : total
			resultLabel.text = ""
			printableTemp = ""
			operating = false
		}
		
		// Si no hay operación limpiamos pantalla
		if operation == .none && inputValue == 0 && !(printableTemp!.contains("0.")) {
			tempValue = 0
			printableTemp = ""
		}
		
		// Si hemos seleccionado decimal
		if decimal {
			if inputValue == 0 {
			printableTemp! = "0."
			}
			decimal = false
		}
		
		// Por defecto
		printableTemp = printableTemp! + String(number)
		print("printableTemp: \(printableTemp!)")
		inputValue = Double(printableTemp!)!
		print("inputValue: \(inputValue)")
		resultLabel.text = printableTemp?.replacingOccurrences(of: ".", with: kDecimalSeparator)
		sender.shine()
	}
	
	// Limpia los valores
	private func clear() {
		operation = .none
		operating = false
		decimal = false
		operatorAC.setTitle("AC", for: .normal)
		if inputValue != 0 {
			inputValue = 0
			resultLabel.text = "0"
		} else {
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
		
		print("input: \(inputValue)")
		print("temp: \(tempValue)")
		print("TOTAL: \(total)")
		
		// Formateo en pantalla
		resultLabel.text = printFormatter.string(from: NSNumber(value: total))
				
		operation = .none
		operating = false
		inputValue = 0
		tempValue = total
		
		// Para guardar el resultado en memoria
		UserDefaults.standard.set(total, forKey: kTotal)
		
		
		
		
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

		inputValue = total != 0 ? total : inputValue
		
		switch mainUnit {
			
			// Pasamos a SECONDS
			case .meters:
				tempValue = tempValue / speedOfSound
				inputValue = inputValue / speedOfSound
				total = total / speedOfSound
				if #available(iOS 13.0, *) {
					unitsSegmentedControl.selectedSegmentTintColor = secondsColor
				}
				break
			
			// Pasamos a METERS
			case .seconds:
				tempValue = tempValue * speedOfSound
				inputValue = inputValue * speedOfSound
				total = total * speedOfSound
				if #available(iOS 13.0, *) {
					unitsSegmentedControl.selectedSegmentTintColor = metersColor
				}
				break
		}
		print("input: \(inputValue)")
		print("temp: \(tempValue)")
		print("TOTAL: \(total)")
		resultLabel.text = printFormatter.string(from: NSNumber(value: inputValue))
				
		switchMainUnit()
		unitsSegmentedControl.selectedSegmentIndex = unitsSGArray.firstIndex(of: mainUnit.rawValue) ?? 0
				
	}
}
