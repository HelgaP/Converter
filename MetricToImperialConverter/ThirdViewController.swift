//
//  ThirdViewController.swift
//  MetricToImperialConverter
//
//  Created by Irina Perepelkina on 12.05.2021.
//  Copyright © 2021 Irina Perepelkina. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    enum TempVersion {
        case CelsiusToFarenheit
        case FahrenheitToCelsius
    }
    
    var version: TempVersion = .CelsiusToFarenheit
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func chooseTempVersion(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        
        if index == 0 {
            version = .CelsiusToFarenheit
        }
        else {
            version = .FahrenheitToCelsius
        }
    }
    
    
    @IBAction func convert(_ sender: UIButton) {
        
        guard let value = textField.text else {
            print("No value to convert provided")
            return}
        
        guard let number = Double (value) else {
            print("Failed to convert a number into double")
            return
        }
        
        if version == .CelsiusToFarenheit {
            let result = number * 9 / 5 + 32
            resultLabel.text = "\(number) degrees celsius is\n\(result) degress fahrenheit"
        }
        else {
            let result = (number - 32) * 5 / 9
            resultLabel.text = "\(number) degrees fahrenheit is\n\(result) degrees celsius"
        }
        
    }
    
    @IBAction func startoverClicked(_ sender: UIButton) {
        
        textField.text?.removeAll()
        version = .CelsiusToFarenheit
        navigationController?.popViewController(animated: true)
    }
    
}
