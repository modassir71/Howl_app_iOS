//
//  AddPersonVm.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation

protocol InitialInfoDelegate{
    func initialBasicInfoVlaidate(name: String, mobileNumber: String, notificationType: String) -> (Bool, String)
}

class AddPersonVm: InitialInfoDelegate{
    func initialBasicInfoVlaidate(name: String, mobileNumber: String, notificationType: String) -> (Bool, String){
        let response = RegistrationValidation.shared.validationBasicInfo(name: name, mobileNumber: mobileNumber, notificationType: notificationType)
        return response
    }
}
