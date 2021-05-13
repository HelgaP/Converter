//
//  SecondViewController.swift
//  MetricToImperialConverter
//
//  Created by Irina Perepelkina on 10.05.2021.
//  Copyright © 2021 Irina Perepelkina. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var chosenMeasure: String? // Weight, length or volume from root VC
    var metricList: [String]? // Get list of metric units from the root VC
    var imperialList: [String]?
    var chosenMetricUnit: String? // From drop down list in a table view
    var chosenImperialUnit: String?
    
    @IBOutlet weak var chosenMeasureLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var metricTable: UITableView!
    @IBOutlet weak var imperialTable: UITableView!
    @IBOutlet weak var metricButton: UIButton!
    @IBOutlet weak var imperialButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func startOverClicked(_ sender: UIButton) {
        
        textField.text?.removeAll()
        option = .MetricToImperial
        metricButton.titleLabel!.text = "Metric unit"
        imperialButton.titleLabel!.text = "Imperial unit"
        resultLabel.text = "Result"
        navigationController?.popViewController(animated: true)
    }
    
    enum Options {
        case MetricToImperial
        case ImperialToMetric
    }
    
    var option: Options = .MetricToImperial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        chosenMeasureLabel.text = "\(chosenMeasure!) converter"
        metricTable.dataSource = self
        imperialTable.dataSource = self
        metricTable.delegate = self
        imperialTable.delegate = self
        metricTable.isHidden = true
        imperialTable.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    // Function to choose between MetricToImperial or ImperialToMetric
    @IBAction func choseOption(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        print("Index is ", index)
        
        if index == 0 {
            option = .MetricToImperial
        }
        else {
            option = .ImperialToMetric
        }
    }
    
    // MARK: - Choose metric and imperial units from drop down lists
     @IBAction func chooseMetricUnit(_ sender: UIButton) {
         
         if metricTable.isHidden == true {
             UIView.animate(withDuration: 1) {
                 self.metricTable.isHidden = false
             }
         }
         else {
             UIView.animate(withDuration: 1) {
                 self.metricTable.isHidden = true
             }
         }
     }
     
     @IBAction func chooseImperialUnit(_ sender: UIButton) {
         
         if imperialTable.isHidden == true {
             UIView.animate(withDuration: 1) {
                 self.imperialTable.isHidden = false
             }
         }
         else {
             UIView.animate(withDuration: 1) {
                 self.imperialTable.isHidden = true
             }
         }
     }
    
    // MARK: - Conversion functions
    
    func calculate (metric: String, imperial: String, number: Double) -> Double {
        // find right coefficient
        let coefDict: [String: Any] = [
            "pounds": ["milligrams": 453592, "grams": 453.592, "kilograms": 0.453592, "tons": 0.000453592],
            "ounces": ["milligrams": 28349.5, "grams": 28.3495, "kilograms": 0.0283495, "tons": 0.0000283495],
            "stones": ["milligrams": 6350290, "grams": 6350.29, "kilograms": 6.35029, "tons": 0.00635029],
            "inches": ["millimeters": 25.4, "centimeters": 2.54, "meters": 0.0254, "kilometers": 0.0000254],
            "feet": ["millimeters": 304.8, "centimeters": 30.48, "meters": 0.3048, "kilometers": 0.0003048],
            "yards": ["millimeters": 914.4, "centimeters": 91.44, "meters": 0.9144, "kilometers": 0.0009144],
            "miles": ["millimeters": 1609340, "centimeters": 160934, "meters": 1609.34, "kilometers": 1.60934],
            "teaspoon": ["milliliters": 4.92892, "deciliters": 0.0492892, "liters": 0.00492892],
            "tablespoon": ["milliliters": 14.7868, "deciliters": 0.147868, "liters": 0.0147868],
            "cups": ["milliliters": 284.131, "deciliters": 2.84131, "liters": 0.284131],
            "quarts": ["milliliters": 1136.52, "deciliters": 11.3652, "liters": 1.13652],
            "gallons": ["milliliters": 4546.09, "deciliters": 45.4609, "liters": 4.54609]
        ]
        let imperialSubDict = coefDict[imperial] as! [String: Double]
        print("imperialSubDict is ", imperialSubDict)
        let coef = imperialSubDict[metric] as! Double
        
        // implement division based on chosen option
        if option == .ImperialToMetric {
            let result = number * coef
            resultLabel.text = "\(number) \(imperial) is\n\(result) \(metric)"
            return result
        }
        else {
            let result = number * (1/coef)
            resultLabel.text = "\(number) \(metric) is\n\(result) \(imperial)"
            return result
        }
    }
    
    @IBAction func convert(_ sender: UIButton) {
        
        // Check that both metric and imperail units are chosen
               guard let metricValue = chosenMetricUnit else {
                   print ("Metric unit is not specified")
                   return
               }
               
               guard let imperialValue = chosenImperialUnit else {
                   print ("Imperial unit is not specified")
                   return
               }
               // Check that textField is not nil and has appropriate value
               guard let numberString = textField.text else {
                   print("Value is not provided")
                   return
               }
               guard let number = Double (numberString) else {
                   print("Failed to convert number into double")
                   return
               }
               // Pass these values to corresponding calculate function
               calculate(metric: metricValue, imperial: imperialValue, number: number)
    }
    
    // MARK: - Clear button
    
    

    
}

// MARK: - Create drop down lists of metric and imperial units

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == metricTable {
            return metricList!.count
        }
        else if tableView == imperialTable {
            return imperialList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dummyCell = UITableViewCell()
        
        if tableView == metricTable {
            guard let cell = metricTable.dequeueReusableCell(withIdentifier: "metricCell") else {return dummyCell}
            cell.textLabel!.text = metricList![indexPath.row]
            return cell
        }
        else if tableView == imperialTable {
            guard let cell = imperialTable.dequeueReusableCell(withIdentifier: "imperialCell") else {return dummyCell}
            cell.textLabel!.text = imperialList![indexPath.row]
            return cell
        }
        return dummyCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == metricTable {
            chosenMetricUnit = metricList![indexPath.row]
            metricButton.titleLabel!.text = chosenMetricUnit
            UIView.animate(withDuration: 0.3) {
                self.metricTable.isHidden = true
            }
        }
        else if tableView == imperialTable {
            chosenImperialUnit = imperialList![indexPath.row]
            print("chosenImperialUnit is ", chosenImperialUnit)
            imperialButton.titleLabel!.text = chosenImperialUnit
            UIView.animate(withDuration: 0.3) {
                self.imperialTable.isHidden = true
            }
        }
    }
}
