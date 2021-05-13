//
//  ViewController.swift
//  MetricToImperialConverter
//
//  Created by Irina Perepelkina on 08.05.2021.
//  Copyright © 2021 Irina Perepelkina. All rights reserved.
//

// Variables:
// Global: measure type, textField (outlet), control (metric/imperial), metric unit/imperial unit, result value. All these are optional and nil in the beginning of the program

// Action to be taken in the first part of the program - segue from OK button to the second screen and store a value

// Sequence of functions for the second part:
// control func: DONE
// choose metric unit func -> store unit in a var and (make sure it's not nil - delegated to convert/calculate function): DONE
// choose imperial unit func -> store unit in a var and make sure it's not nil: DONE
// specify all necessary data in the form of enumerations: DONE
// convert -> calculation func () based on all chosen data above. 1) Calculation func should work both ways and clear text field; DONE
// ** calculation function should check if all necessary data is received; DONE
// displayTheResult func to display result in label: DONE
// startOver func -> clears all vars and takes the user back to the home screen: DONE

// Description: when OK is pressed on the first screen, measure type is transferred to the second screen
// when convert is clicked program needs all vars below to be already specified and not nil:
// controlFunc metric to imperial or vice versa,
// metric unit
// imperial unit
// After convert function is called, it reads value from a textField


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var measureTypeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var options = ["Weight", "Length", "Volume", "Temperature"]
    var chosenMeasure: String?
    
    var dict: [String: Any] = [
        "Weight": [
            "imperial": ["pounds", "ounces", "stones"],
            "metric": ["milligrams", "grams", "kilograms", "tons"]
        ],
        "Length": [
            "imperial": ["inches", "feet", "yards", "miles"],
            "metric": ["millimeters", "centimeters", "meters", "kilometers"]
        ],
        "Volume": [
            "imperial": ["teaspoon", "tablespoon", "cups", "quarts", "gallons"],
            "metric": ["milliliters", "deciliters", "liters"]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: row, animated: true)
        }
    }
    
    
    @IBAction func measureTypeButtonClicked(_ sender: UIButton) {
        
        if tableView.isHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = false
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = true
            }
        }
    }
    
    
    @IBAction func OKbuttonClicked(_ sender: Any) {
        
        guard let chosenOption = chosenMeasure else {
            print("No option is chosen")
            return
        }
        
        if chosenOption == "Temperature" {
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            print("Got inside okbuttonclicked function")
            let destinationVC = storyBoard.instantiateViewController(identifier: "TemperatureConverter") as! ThirdViewController
            print("Created destiationVC object")
            navigationController?.pushViewController(destinationVC, animated: true)
            print("Pushed destinationVC on stack")
        }
        
        else {
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destinationVC = storyBoard.instantiateViewController(identifier: "Converter") as! SecondViewController
            
            destinationVC.chosenMeasure = chosenOption
            
            let measureDict = dict[chosenOption] as! [String:[String]]
            
            let metricPart = measureDict["metric"]!
            let imperialPart = measureDict["imperial"]!
            
            destinationVC.metricList = metricPart
            destinationVC.imperialList = imperialPart
            
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        
        tableView.isHidden = true
    }
    
    
}

// MARK: - Table View Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TheCell") as! UITableViewCell
        
        cell.textLabel!.text = options[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        chosenMeasure = options[indexPath.row]

    }
    
}
