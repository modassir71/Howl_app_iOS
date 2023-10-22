//
//  AddNewPersonModel.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation

struct Person: Codable {
    
    // Variables
    var personName: String!
  //  var personNickname: String!
  //  var personCountryDialCode: String!
    var personCountryCode: String!
    var personMobileNumber: String!
    var personNotificationType = "WHATSAPP"
    var personImage: Data!
    
    enum CodingKeys: String, CodingKey {
        
        case personName
      //  case personNickname
        case personCountryDialCode
        case personCountryCode
        case personMobileNumber
        case personNotificationType
        case personImage
    }
    
    init(
        name: String,
      //  nickname: String,
       // countryDialCode: String,
        countryCode: String,
        mobileNumber: String,
        notificationType: String,
        image: Data
    ) {
        personName = name
    //    personNickname = nickname
     //   personCountryDialCode = countryDialCode
        personCountryCode = countryCode
        personMobileNumber = mobileNumber
        personNotificationType = notificationType
        personImage = image
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(personName, forKey: .personName)
      //  try container.encode(personNickname, forKey: .personNickname)
      //  try container.encode(personCountryDialCode, forKey: .personCountryDialCode)
        try container.encode(personCountryCode, forKey: .personCountryCode)
        try container.encode(personMobileNumber, forKey: .personMobileNumber)
        try container.encode(personNotificationType, forKey: .personNotificationType)
        try container.encode(personImage, forKey: .personImage)
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        personName = try container.decode(String.self, forKey: .personName)
       // personNickname = try container.decode(String.self, forKey: .personNickname)
       // personCountryDialCode = try container.decode(String.self, forKey: .personCountryDialCode)
        personCountryCode = try container.decode(String.self, forKey: .personCountryCode)
        personMobileNumber = try container.decode(String.self, forKey: .personMobileNumber)
        personNotificationType = try container.decode(String.self, forKey: .personNotificationType)
        personImage = try container.decode(Data.self, forKey: .personImage)
    }
}
