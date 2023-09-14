//
//  AddPersonVm.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation

protocol InitialInfoDelegate{
    func initialBasicInfoVlaidate(name: String, nickName: String, mobileNumber: String) -> (Bool, String)
}

class AddPersonVm: InitialInfoDelegate{
    func initialBasicInfoVlaidate(name: String, nickName: String, mobileNumber: String) -> (Bool, String){
        let response = RegistrationValidation.shared.validationBasicInfo(name: name, nickName: nickName, mobileNumber: mobileNumber)
        return response
    }
}
