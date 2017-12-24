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
    
    func updateCelciusLabel() {
        if let celciusValue = celciusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value:celciusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSearator = string.range(of: ".")
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
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}

































