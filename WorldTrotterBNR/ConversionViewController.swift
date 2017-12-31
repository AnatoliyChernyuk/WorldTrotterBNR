//
//  ConversionViewController.swift
//  WorldTrotterBNR
//
//  Created by Anatoliy Chernyuk on 12/23/17.
//  Copyright © 2017 Anatoliy Chernyuk. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelciusLabel()
        }
    }
    var celciusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCelciusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now) // The best solution at the forum
        
        /* Mine solution neglecting the calendric calculations
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let dateString = formatter.string(from: now)
        var hrsString = ""
        for c in dateString {
            if c == ":" {
                break
            }
            hrsString += String(c)
        }
        var hrsInt: Int = Int(hrsString)!
        let meridiem = dateString[dateString.index(dateString.endIndex, offsetBy: -2)]
        switch meridiem {
        case "P":
            hrsInt += 12
        default:
            break
        }
         */
        if hour < 6 || hour > 14 {
            view.backgroundColor = UIColor.black
        }
    }
 
    
    func updateCelciusLabel() {
        if let celciusValue = celciusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value:celciusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSearator = string.range(of: decimalSeparator)
        let isNum = Int(string)
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSearator != nil {
            return false
        } else if isNum != nil || replacementTextHasDecimalSearator != nil || string == "" { //The last check is for enabling delete button
            return true
        } else {
            return false
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: value.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}

































