//
//  Helpers.swift
//  Just Move Simple
//
//  Created by Peter Farrell on 02/05/2020.
//  Copyright © 2020 App Intelligence Ltd. All rights reserved.
//

import UIKit
import Foundation

class Helpers {
    
    // MARK: ATTRIBUTED STRING
    // Return attributed string for bold VS regular comparator
    func createdAttributedTextBoldVSRegular(boldString: String!, regularString: String!) -> NSAttributedString {
        
        // Set attributes for making string output bold VS regular
        let bold = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        let regular = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular)
        ]
        
        let boldText = NSAttributedString(string: boldString, attributes: bold)
        let regularText = NSAttributedString(string: regularString, attributes: regular)
        
        let output = NSMutableAttributedString()
        output.append(boldText)
        output.append(regularText)
        
        return output
    }
    
    //MARK: SPEECH OUTPUT
    func returnSpeechOutputState() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "SpeechOutput")
    }
    
    //MARK: NOTIFICATION OBSERVERS
    func addObservers(initialiser: UIViewController, names: [String]) {
        
        // Loop the list of notifications adding them to view
        for name in names {
            
            NotificationCenter.default.addObserver(initialiser,
                                                   selector: #selector(initialiser.processNetworkResponse(_:)),
                                                   name: NSNotification.Name(rawValue: name),
                                                   object: nil)
        }
        
        kSystemLog.updateLog(logEntry: "OBSERVERS ADDED TO \(initialiser) ARE \(names)")
    }
    
    func removeObservers(initialiser: UIViewController, names: [String]) {
        
        // Loop the list of notifications removing them from the view
        for name in names {
            
            NotificationCenter.default.removeObserver(initialiser,
                                                      name: NSNotification.Name(rawValue: name),
                                                      object: nil)
        }
        
        kSystemLog.updateLog(logEntry: "OBSERVERS REMOVED FROM \(initialiser) ARE \(names)")
    }
    
    //MARK: DATE & TIME
    // Delay Timer
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    // Return Date and Time
    func returnTodaysDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: Date())
    }
    
    func returnTheTimeNow() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    //MARK: UDID CREATION
    // Create a unique ID using the UDID of the device concatenated with the date and time
    func returnUniqueID() -> String {
        
        var uniqueID = UserDefaults.standard.value(forKey: "UUID") as! String + returnTodaysDate() + returnTheTimeNow()
        
        uniqueID = uniqueID.replacingOccurrences(of: "-", with: "")
        uniqueID = uniqueID.replacingOccurrences(of: "/", with: "")
        uniqueID = uniqueID.replacingOccurrences(of: ":", with: "")
        return uniqueID
    }
    
    //MARK: UITEXTFIELDS
    // Calculates the new Y axis required to offset the keyboard to the text field being input
    func returnScreenOffsetForKeyboardAccess(keyboardY: CGFloat, inputFieldHeight: CGFloat, inputFieldY: CGFloat) -> CGFloat! {
        
        var newYAxisOrigin = keyboardY
        
        newYAxisOrigin = newYAxisOrigin - 8 // Minus 8 for the standard distance between objects
        newYAxisOrigin = newYAxisOrigin - inputFieldHeight // Minus the height of the input field
        newYAxisOrigin = newYAxisOrigin - inputFieldY // Minust the Y axis of the input field
        
        return newYAxisOrigin
    }
    
    // Return a list of text fields within the view and their origin.y value
    func returnAllTextfieldData(views: [UIView]) -> [UITextField]! {
        
        var textFieldInfo: [UITextField] = []
        
        for view in views {
            
            if let textField = view as? UITextField {
                
                textFieldInfo.append(textField)
            }
        }
        return textFieldInfo
    }
    
    // Check all text fields are completed and highlight red if not returning a bool to confirm.  Ignore fields not required
    func cycleTextFieldsToConfirmInputRequired(inputTextFields: [UITextField], fieldAttributes: [[String : Any]]) -> Bool! {
        
        // Possible Field Attributes
        // REQUIRED = Is the field required to have input to proceed
        // FIXEDLENGTH = Must be a set number of characters
        // MINLENGTH = Must be at least minimum length of characters
        // MAXLENGTH = Must be no more than a maximum length of characters
        // ALPHANUMERIC = The character set must be alphanumeric only
        
        var inputComplete = true
        
        for attributes in fieldAttributes {
            
            // A scoring mechanism that starts at 0 for each field and accumulates if there are errors until completion of tests
            var scoring = 0
            
            // Set the textfield for review
            let inputField = attributes["FIELD"] as! UITextField
            
            if attributes["REQUIRED"] != nil {
                
                // If the field is required set the score to a starting point of 1 if not populated
                if inputField.text == "" {
                    
                    scoring = 1
                }
            }
            
            if let value = attributes["FIXEDLENGTH"] as? Int {
                
                // Return a positive or negative score for passing the test
                let score = testFixedLength(inputField: inputField, length: value)
                
                var testStatus = "PASSED"
                
                if score == true {
                    
                    testStatus = "FAILED"
                }
                
                // Update the log to give the user visibility of the input issue
                kSystemLog.updateLog(logEntry: "Field: \(inputField) Scored: \(testStatus) Test: FIXEDLENGTH View: \(String(describing: kDataManager.onScreenViewController))")
                
                // Update the scoring mechanism
                scoring = scoring + score.intValue()
                kSystemLog.updateLog(logEntry: "Field: \(inputField) Scored: \(testStatus) Test: FIXEDLENGTH VIEW: \(String(describing: kDataManager.onScreenViewController))")
            }
            
            if let value = attributes["MINLENGTH"] as? Int {
                
                // Return a positive or negative score for passing the test
                let score = testMinLength(inputField: inputField, length: value)
                
                var testStatus = "PASSED"
                
                if score == true {
                    
                    testStatus = "FAILED"
                }
                
                // Update the log to give the user visibility of the input issue
                kSystemLog.updateLog(logEntry: "Field: \(inputField) Scored: \(testStatus) Test: MINLENGTH View: \(String(describing: kDataManager.onScreenViewController))")
                
                // Update the scoring mechanism
                scoring = scoring + score.intValue()
            }
            
            if let value = attributes["MAXLENGTH"] as? Int {
                
                // Return a positive or negative score for passing the test
                let score = testMaxLength(inputField: inputField, length: value)
                
                var testStatus = "PASSED"
                
                if score == true {
                    
                    testStatus = "FAILED"
                }
                
                // Update the log to give the user visibility of the input issue
                kSystemLog.updateLog(logEntry: "Field: \(inputField) Scored: \(testStatus) Test: MAXLENGTH View: \(String(describing: kDataManager.onScreenViewController))")
                
                // Update the scoring mechanism
                scoring = scoring + score.intValue()
            }
            
            if attributes["ALPHANUMERIC"] != nil {
                
                // Return a positive or negative score for passing the test
                let score = testAlphanumeric(inputField: inputField)
                
                var testStatus = "PASSED"
                
                if score == true {
                    
                    testStatus = "FAILED"
                }
                
                // Update the log to give the user visibility of the input issue
                kSystemLog.updateLog(logEntry: "Field: \(inputField) Scored: \(testStatus) Test: ALPHANUMERIC View: \(String(describing: kDataManager.onScreenViewController))")
                
                // Update the scoring mechanism
                scoring = scoring + score.intValue()
            }
            
            if scoring > 0 {
                
                // Failed at least one of the tests, set as red
                inputField.backgroundColor = .red
                
                // If any one instance of input complete fails, all input fails
                if inputComplete == true {
                    
                    inputComplete = false
                }
            } else {
                
                // Passed all tests set as clear
                inputField.backgroundColor = .clear
            }
        }
        
        return inputComplete
    }
    
    private func testFixedLength(inputField: UITextField, length: Int) -> Bool {
        
        
        // Compare number of input characters to character length required
        if inputField.text!.count == length {
            
            return false
        }
        
        return true
    }
    
    private func testMinLength(inputField: UITextField, length: Int) -> Bool {
        
        // Compare number of input characters to minimum character length required
        if inputField.text!.count >= length {
            
            return false
        }
        
        return true
    }
    
    private func testMaxLength(inputField: UITextField, length: Int) -> Bool {
        
        // Compare number of input characters to maximum character length required
        if inputField.text!.count <= length {
            
            return false
        }
        
        return true
    }
    
    private func testAlphanumeric(inputField: UITextField) -> Bool {
        
        // If input is alphnumeric return true
        if inputField.text!.isAlphanumeric(ignoreDiacritics: true) {
            
            return false
        }
        
        return true
    }
    
    //MARK: GLOBAL CURRENCIES
    // Global curncy including name and ISO code
    func returnGlobalCurrencies() -> [[String : String]] {
        
        let currencies = [
            ["CURRENCY":"UAE dirham","ISO-4217":"AED"],
            ["CURRENCY":"Afghan afghani","ISO-4217":"AFN"],
            ["CURRENCY":"Albanian lek","ISO-4217":"ALL"],
            ["CURRENCY":"Armenian dram","ISO-4217":"AMD"],
            ["CURRENCY":"Netherlands Antillean guilder","ISO-4217":"ANG"],
            ["CURRENCY":"Angolan kwanza","ISO-4217":"AOA"],
            ["CURRENCY":"Argentine peso","ISO-4217":"ARS"],
            ["CURRENCY":"Australian dollar","ISO-4217":"AUD"],
            ["CURRENCY":"Aruban florin","ISO-4217":"AWG"],
            ["CURRENCY":"Azerbaijan manat","ISO-4217":"AZN"],
            ["CURRENCY":"Bosnia and Herzegovina convertible mark","ISO-4217":"BAM"],
            ["CURRENCY":"Barbadian dollar","ISO-4217":"BBD"],
            ["CURRENCY":"Bangladeshi taka","ISO-4217":"BDT"],
            ["CURRENCY":"Bulgarian lev","ISO-4217":"BGN"],
            ["CURRENCY":"Bahraini dinar","ISO-4217":"BHD"],
            ["CURRENCY":"Burundi franc","ISO-4217":"BIF"],
            ["CURRENCY":"Bermudian dollar","ISO-4217":"BMD"],
            ["CURRENCY":"Brunei dollar","ISO-4217":"BND"],
            ["CURRENCY":"Bolivian boliviano","ISO-4217":"BOB"],
            ["CURRENCY":"Brazilian real","ISO-4217":"BRL"],
            ["CURRENCY":"Bahamian dollar","ISO-4217":"BSD"],
            ["CURRENCY":"Bhutanese ngultrum","ISO-4217":"BTN"],
            ["CURRENCY":"Botswana pula","ISO-4217":"BWP"],
            ["CURRENCY":"Belarusian ruble","ISO-4217":"BYN"],
            ["CURRENCY":"Belize dollar","ISO-4217":"BZD"],
            ["CURRENCY":"Canadian dollar","ISO-4217":"CAD"],
            ["CURRENCY":"Congolese franc","ISO-4217":"CDF"],
            ["CURRENCY":"Swiss franc","ISO-4217":"CHF"],
            ["CURRENCY":"Chilean peso","ISO-4217":"CLP"],
            ["CURRENCY":"Chinese Yuan Renminbi","ISO-4217":"CNY"],
            ["CURRENCY":"Colombian peso","ISO-4217":"COP"],
            ["CURRENCY":"Costa Rican colon","ISO-4217":"CRC"],
            ["CURRENCY":"Cuban peso","ISO-4217":"CUP"],
            ["CURRENCY":"Cape Verdean escudo","ISO-4217":"CVE"],
            ["CURRENCY":"Czech koruna","ISO-4217":"CZK"],
            ["CURRENCY":"Djiboutian franc","ISO-4217":"DJF"],
            ["CURRENCY":"Danish krone","ISO-4217":"DKK"],
            ["CURRENCY":"Dominican peso","ISO-4217":"DOP"],
            ["CURRENCY":"Algerian dinar","ISO-4217":"DZD"],
            ["CURRENCY":"Egyptian pound","ISO-4217":"EGP"],
            ["CURRENCY":"Eritrean nakfa","ISO-4217":"ERN"],
            ["CURRENCY":"Ethiopian birr","ISO-4217":"ETB"],
            ["CURRENCY":"European euro","ISO-4217":"EUR"],
            ["CURRENCY":"Fijian dollar","ISO-4217":"FJD"],
            ["CURRENCY":"Falkland Islands pound","ISO-4217":"FKP"],
            ["CURRENCY":"Pound sterling","ISO-4217":"GBP"],
            ["CURRENCY":"Georgian lari","ISO-4217":"GEL"],
            ["CURRENCY":"Guernsey Pound","ISO-4217":"GGP"],
            ["CURRENCY":"Ghanaian cedi","ISO-4217":"GHS"],
            ["CURRENCY":"Gibraltar pound","ISO-4217":"GIP"],
            ["CURRENCY":"Gambian dalasi","ISO-4217":"GMD"],
            ["CURRENCY":"Guinean franc","ISO-4217":"GNF"],
            ["CURRENCY":"Guatemalan quetzal","ISO-4217":"GTQ"],
            ["CURRENCY":"Guyanese dollar","ISO-4217":"GYD"],
            ["CURRENCY":"Hong Kong dollar","ISO-4217":"HKD"],
            ["CURRENCY":"Honduran lempira","ISO-4217":"HNL"],
            ["CURRENCY":"Croatian kuna","ISO-4217":"HRK"],
            ["CURRENCY":"Haitian gourde","ISO-4217":"HTG"],
            ["CURRENCY":"Hungarian forint","ISO-4217":"HUF"],
            ["CURRENCY":"Indonesian rupiah","ISO-4217":"IDR"],
            ["CURRENCY":"Israeli new shekel","ISO-4217":"ILS"],
            ["CURRENCY":"Manx pound","ISO-4217":"IMP"],
            ["CURRENCY":"Indian rupee","ISO-4217":"INR"],
            ["CURRENCY":"Iraqi dinar","ISO-4217":"IQD"],
            ["CURRENCY":"Iranian rial","ISO-4217":"IRR"],
            ["CURRENCY":"Icelandic krona","ISO-4217":"ISK"],
            ["CURRENCY":"Jersey pound","ISO-4217":"JEP"],
            ["CURRENCY":"Jamaican dollar","ISO-4217":"JMD"],
            ["CURRENCY":"Jordanian dinar","ISO-4217":"JOD"],
            ["CURRENCY":"Japanese yen","ISO-4217":"JPY"],
            ["CURRENCY":"Kenyan shilling","ISO-4217":"KES"],
            ["CURRENCY":"Kyrgyzstani som","ISO-4217":"KGS"],
            ["CURRENCY":"Cambodian riel","ISO-4217":"KHR"],
            ["CURRENCY":"Comorian franc","ISO-4217":"KMF"],
            ["CURRENCY":"North Korean won","ISO-4217":"KPW"],
            ["CURRENCY":"South Korean won","ISO-4217":"KRW"],
            ["CURRENCY":"Kuwaiti dinar","ISO-4217":"KWD"],
            ["CURRENCY":"Cayman Islands dollar","ISO-4217":"KYD"],
            ["CURRENCY":"Kazakhstani tenge","ISO-4217":"KZT"],
            ["CURRENCY":"Lao kip","ISO-4217":"LAK"],
            ["CURRENCY":"Lebanese pound","ISO-4217":"LBP"],
            ["CURRENCY":"Sri Lankan rupee","ISO-4217":"LKR"],
            ["CURRENCY":"Liberian dollar","ISO-4217":"LRD"],
            ["CURRENCY":"Lesotho loti","ISO-4217":"LSL"],
            ["CURRENCY":"Libyan dinar","ISO-4217":"LYD"],
            ["CURRENCY":"Moroccan dirham","ISO-4217":"MAD"],
            ["CURRENCY":"Moldovan leu","ISO-4217":"MDL"],
            ["CURRENCY":"Malagasy ariary","ISO-4217":"MGA"],
            ["CURRENCY":"Macedonian denar","ISO-4217":"MKD"],
            ["CURRENCY":"Myanmar kyat","ISO-4217":"MMK"],
            ["CURRENCY":"Mongolian tugrik","ISO-4217":"MNT"],
            ["CURRENCY":"Macanese pataca","ISO-4217":"MOP"],
            ["CURRENCY":"Mauritanian ouguiya","ISO-4217":"MRU"],
            ["CURRENCY":"Mauritian rupee","ISO-4217":"MUR"],
            ["CURRENCY":"Maldivian rufiyaa","ISO-4217":"MVR"],
            ["CURRENCY":"Malawian kwacha","ISO-4217":"MWK"],
            ["CURRENCY":"Mexican peso","ISO-4217":"MXN"],
            ["CURRENCY":"Malaysian ringgit","ISO-4217":"MYR"],
            ["CURRENCY":"Mozambican metical","ISO-4217":"MZN"],
            ["CURRENCY":"Namibian dollar","ISO-4217":"NAD"],
            ["CURRENCY":"Nigerian naira","ISO-4217":"NGN"],
            ["CURRENCY":"Nicaraguan cordoba","ISO-4217":"NIO"],
            ["CURRENCY":"Norwegian krone","ISO-4217":"NOK"],
            ["CURRENCY":"Cook Islands dollar","ISO-4217":"none"],
            ["CURRENCY":"Faroese krona","ISO-4217":"none"],
            ["CURRENCY":"Nepalese rupee","ISO-4217":"NPR"],
            ["CURRENCY":"New Zealand dollar","ISO-4217":"NZD"],
            ["CURRENCY":"Omani rial","ISO-4217":"OMR"],
            ["CURRENCY":"Peruvian sol","ISO-4217":"PEN"],
            ["CURRENCY":"Papua New Guinean kina","ISO-4217":"PGK"],
            ["CURRENCY":"Philippine peso","ISO-4217":"PHP"],
            ["CURRENCY":"Pakistani rupee","ISO-4217":"PKR"],
            ["CURRENCY":"Polish zloty","ISO-4217":"PLN"],
            ["CURRENCY":"Paraguayan guarani","ISO-4217":"PYG"],
            ["CURRENCY":"Qatari riyal","ISO-4217":"QAR"],
            ["CURRENCY":"Romanian leu","ISO-4217":"RON"],
            ["CURRENCY":"Serbian dinar","ISO-4217":"RSD"],
            ["CURRENCY":"Russian ruble","ISO-4217":"RUB"],
            ["CURRENCY":"Rwandan franc","ISO-4217":"RWF"],
            ["CURRENCY":"Saudi Arabian riyal","ISO-4217":"SAR"],
            ["CURRENCY":"Solomon Islands dollar","ISO-4217":"SBD"],
            ["CURRENCY":"Seychellois rupee","ISO-4217":"SCR"],
            ["CURRENCY":"Sudanese pound","ISO-4217":"SDG"],
            ["CURRENCY":"Swedish krona","ISO-4217":"SEK"],
            ["CURRENCY":"Singapore dollar","ISO-4217":"SGD"],
            ["CURRENCY":"Saint Helena pound","ISO-4217":"SHP"],
            ["CURRENCY":"Sierra Leonean leone","ISO-4217":"SLL"],
            ["CURRENCY":"Somali shilling","ISO-4217":"SOS"],
            ["CURRENCY":"Surinamese dollar","ISO-4217":"SRD"],
            ["CURRENCY":"South Sudanese pound","ISO-4217":"SSP"],
            ["CURRENCY":"Sao Tome and Principe dobra","ISO-4217":"STN"],
            ["CURRENCY":"Syrian pound","ISO-4217":"SYP"],
            ["CURRENCY":"Swazi lilangeni","ISO-4217":"SZL"],
            ["CURRENCY":"Thai baht","ISO-4217":"THB"],
            ["CURRENCY":"Tajikistani somoni","ISO-4217":"TJS"],
            ["CURRENCY":"Turkmen manat","ISO-4217":"TMT"],
            ["CURRENCY":"Tunisian dinar","ISO-4217":"TND"],
            ["CURRENCY":"Tongan pa’anga","ISO-4217":"TOP"],
            ["CURRENCY":"Turkish lira","ISO-4217":"TRY"],
            ["CURRENCY":"Trinidad and Tobago dollar","ISO-4217":"TTD"],
            ["CURRENCY":"New Taiwan dollar","ISO-4217":"TWD"],
            ["CURRENCY":"Tanzanian shilling","ISO-4217":"TZS"],
            ["CURRENCY":"Ukrainian hryvnia","ISO-4217":"UAH"],
            ["CURRENCY":"Ugandan shilling","ISO-4217":"UGX"],
            ["CURRENCY":"United States dollar","ISO-4217":"USD"],
            ["CURRENCY":"Uruguayan peso","ISO-4217":"UYU"],
            ["CURRENCY":"Uzbekistani som","ISO-4217":"UZS"],
            ["CURRENCY":"Venezuelan bolivar","ISO-4217":"VES"],
            ["CURRENCY":"Vietnamese dong","ISO-4217":"VND"],
            ["CURRENCY":"Vanuatu vatu","ISO-4217":"VUV"],
            ["CURRENCY":"Samoan tala","ISO-4217":"WST"],
            ["CURRENCY":"Central African CFA franc","ISO-4217":"XAF"],
            ["CURRENCY":"East Caribbean dollar","ISO-4217":"XCD"],
            ["CURRENCY":"SDR (Special Drawing Right)","ISO-4217":"XDR"],
            ["CURRENCY":"West African CFA franc","ISO-4217":"XOF"],
            ["CURRENCY":"CFP franc","ISO-4217":"XPF"],
            ["CURRENCY":"Yemeni rial","ISO-4217":"YER"],
            ["CURRENCY":"South African rand","ISO-4217":"ZAR"],
            ["CURRENCY":"Zambian kwacha","ISO-4217":"ZMW"]
        ]
        
        return currencies
    }
}
extension Bool {
    
    func intValue() -> Int {
        
        if self == true {
            
            return 1
        }
        return 0
    }
}
extension UIViewController {

    var top: UIViewController? {
        if let controller = self as? UINavigationController {
            return controller.topViewController?.top
        }
        if let controller = self as? UISplitViewController {
            return controller.viewControllers.last?.top
        }
        if let controller = self as? UITabBarController {
            return controller.selectedViewController?.top
        }
        if let controller = presentedViewController {
            return controller.top
        }
        return self
    }
    
    @objc func processNetworkResponse(_ notification: NSNotification) {
        // Never called here - allows all UIViewControllers to override this notification process
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
