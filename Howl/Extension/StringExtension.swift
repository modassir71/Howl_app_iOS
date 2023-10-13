//
//  StringExtension.swift
//  Howl
//
//  Created by apple on 10/10/23.
//

import Foundation
import UIKit

//MARK: STRING
extension String {
    
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func toBool() -> Bool! {
        
        switch self {
            
        case "True", "true", "yes", "1":
            return true
            
        case "False", "false", "no", "0":
            return false
            
        default:
            return nil
        }
    }
    
    func base64Encoded() -> String? {
        
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    
    
    func convertStringDataToSwiftDictionary() -> Dictionary<String,Any>? {
        
        // Base 64 encode the string
        if let base64String = self.base64Encoded() {
            
            do {
                // Convert to Data
                let base64Data = base64String.data(using: String.Encoding.utf8, allowLossyConversion: true)
                
                // Base 64 encode the data
                if let JSONData = Data(base64Encoded: base64Data!, options: NSData.Base64DecodingOptions()) {
                    
                    let jsonDictionary = try JSONSerialization.jsonObject(with: JSONData, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any>
                    
                    return jsonDictionary!
                    
                } else {
                    
                    return nil
                }
            } catch _ {
                
                return nil
            }
        } else {
            return nil
        }
    }
    
    func convertStringtoDatatoArray() -> [[String:String]]? {
        
        // Base 64 encode the string
        if let base64String = self.base64Encoded() {
            
            // Convert to Data
            let base64Data = base64String.data(using: String.Encoding.utf8, allowLossyConversion: true)
            
            // Base 64 encode the data
            if let JSONData = Data(base64Encoded: base64Data!, options: NSData.Base64DecodingOptions()) {
                
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: JSONData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:String]]
                    return jsonDictionary
                    
                } catch {
                    
                    return nil
                }
                
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // Confirm CGSize of label to hold the string within its bounds
    func SizeOfString( font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size;
    }
    
    func isAlphanumeric() -> Bool {
        
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
    
    func isAlphanumeric(ignoreDiacritics: Bool = false) -> Bool {
        
        if ignoreDiacritics {
            
            return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil && self != ""
        } else {
            return self.isAlphanumeric()
        }
    }
    
    subscript (i: Int) -> Character? {
        
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
    
    func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNPQRSTUVWXYZ123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
extension Data {
    
    func base64EncodedToArray() -> [Dictionary<String,Any>]? {
        
        guard let data = Data(base64Encoded: self) else { return nil }
        
        do {
            
            let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            return jsonArray
        } catch {
            
            return nil
        }
    }
    
    func base64EncodedToDictionary() -> Dictionary<String,String>? {
        
        guard let data = Data(base64Encoded: self) else { return nil }
        
        do {
            
            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,String>
            return jsonDictionary
        } catch {
            
            return nil
        }
    }
    
    func convertBase64JSONArrayToSwiftDictionary() -> Dictionary<String,Any>! {
        
        // Confirm there is data to process
        if let JSONData = Data(base64Encoded: self, options: NSData.Base64DecodingOptions()) {
            
            do {
                
                let jsonDictionary = try JSONSerialization.jsonObject(with: JSONData,
                                                                      options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any>
                
                if kDeepDataLogging {
                    
                    print("CONVERT BASE64 JSON ARRAY TO DICTIONARY:")
                    print(String(describing: jsonDictionary))
                }
                
                return jsonDictionary!
                
            } catch _ {
                
                return nil
            }
        } else {
            
            return nil
        }
    }
    
    func jsonDataToDictionary() -> [String:String]? {
        
        do {
            
            let jsonToDictionary = try JSONSerialization.jsonObject(with: self,
                                                                  options : .mutableContainers) as? [String:String]

            if kDeepDataLogging {
                
                print("CONVERT JSON TO DICTIONARY:")
                print(String(describing: jsonToDictionary))
            }
            
            return jsonToDictionary
        } catch _ {
            
            return nil
        }
    }
}
