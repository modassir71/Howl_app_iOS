//
//  DogRegistrationValidation.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation
final class RegistrationValidation {
    static let shared = RegistrationValidation()
    
    private init() {}
    
//    MARK: - User Validation
    
    func validationBasicInfo(name: String?, mobileNumber: String?) -> (Bool, String) {
        guard name != "" && mobileNumber != "" else {
            return (false, "Please fill the required fields")
        }
        
//        guard name!.count >= 3 && containsOnlyCharacters(name!) == true else {
//            return (false, "Enter your valid name")
//        }
        
//        guard nickName!.count >= 3 && containsOnlyCharacters(nickName!) == true else {
//            return (false, "Enter your valid nick name")
//        }
        
        if mobileNumber != "" {
            guard containsOnlyNumbers(mobileNumber!) == true else {
                return (false, "Enter your valid mobile number")
            }
        }
        return (true, "Validation successfull")
    }
    
//    MARK: - Dog Validation
    
    func validationDogInfo(dogName: String?, breed: String?, color: String?, dob: String?, microchipDb: String?, microchipNo: String?, districtiveFeature: String?) ->(Bool, String){
        guard dogName != "" && breed != "" && color !=  "" && dob != "" && microchipDb != "" && microchipNo != "" && districtiveFeature != "" else{
            return (false, "Please fill the required fields")
        }
        return (true, "Validation successfull")
    }
}

extension RegistrationValidation {
    func containsOnlyCharacters(_ input: String) -> Bool {
        let characterSet = CharacterSet.letters
        return input.rangeOfCharacter(from: characterSet.inverted) == nil
    }
    
    func containsOnlyNumbers(_ input: String) -> Bool {
        let numericCharacterSet = CharacterSet.decimalDigits
        let inputCharacterSet = CharacterSet(charactersIn: input)
        return numericCharacterSet.isSuperset(of: inputCharacterSet)
    }
}
