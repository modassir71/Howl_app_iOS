//
//  AddDogVm.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation
protocol InitialDogInfoDelegate{
    func initialDogInfoVlaidate(dogName: String, breed: String, color: String, dob: String, districtiveFeature: String, gender: String, type: String) -> (Bool, String)
}


class AddDogVm: InitialDogInfoDelegate{
    func initialDogInfoVlaidate(dogName: String, breed: String, color: String, dob: String, districtiveFeature: String, gender: String, type: String) -> (Bool, String){
        let response = RegistrationValidation.shared.validationDogInfo(dogName: dogName, breed: breed, color: color, dob: dob, districtiveFeature: districtiveFeature, gender: gender, type: type)
        return response
    }
}
