//
//  AddNewDogModel.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation
struct Dog: Codable {
    
    // Variables
    var dogName: String!
    var dogSex: String!
    var dogBreed: String!
    var dogColour: String!
    var dogDOB: String!
    var dogNeuteredOrSpayed: String!
    var dogDistinctiveFeatures: String!
    var dogMicrochipNumber: String!
    var dogMicrochipSupplier: String!
    var dogStolen: Bool!
    var dogImage: Data!
    var dogIncident: [WalkUpdate]!
    
    enum CodingKeys: String, CodingKey {
        
        case dogName
        case dogSex
        case dogBreed
        case dogColour
        case dogDOB
        case dogNeuteredOrSpayed
        case dogDistinctiveFeatures
        case dogMicrochipNumber
        case dogMicrochipSupplier
        case dogStolen
        case dogImage
        case dogIncident
    }
    
    init(
        name: String,
        sex: String,
        breed: String,
        colour: String,
        dob: String,
        neuteredOrSpayed: String,
        distinctiveFeatures: String,
        microchipNumber: String,
        microchipSupplier: String,
        stolen: Bool,
        image: Data,
        incident: [WalkUpdate]
    ) {
        dogName = name
        dogSex = sex
        dogBreed = breed
        dogColour = colour
        dogDOB = dob
        dogNeuteredOrSpayed = neuteredOrSpayed
        dogDistinctiveFeatures = distinctiveFeatures
        dogMicrochipNumber = microchipNumber
        dogMicrochipSupplier = microchipSupplier
        dogStolen = stolen
        dogImage = image
        dogIncident = incident
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dogName, forKey: .dogName)
        try container.encode(dogSex, forKey: .dogSex)
        try container.encode(dogBreed, forKey: .dogBreed)
        try container.encode(dogColour, forKey: .dogColour)
        try container.encode(dogDOB, forKey: .dogDOB)
        try container.encode(dogNeuteredOrSpayed, forKey: .dogNeuteredOrSpayed)
        try container.encode(dogDistinctiveFeatures, forKey: .dogDistinctiveFeatures)
        try container.encode(dogMicrochipNumber, forKey: .dogMicrochipNumber)
        try container.encode(dogMicrochipSupplier, forKey: .dogMicrochipSupplier)
        try container.encode(dogStolen, forKey: .dogStolen)
        try container.encode(dogImage, forKey: .dogImage)
        try container.encode(dogIncident, forKey: .dogIncident)
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        dogName = try container.decode(String.self, forKey: .dogName)
        dogSex = try container.decode(String.self, forKey: .dogSex)
        dogBreed = try container.decode(String.self, forKey: .dogBreed)
        dogColour = try container.decode(String.self, forKey: .dogColour)
        dogDOB = try container.decode(String.self, forKey: .dogDOB)
        dogNeuteredOrSpayed = try container.decode(String.self, forKey: .dogNeuteredOrSpayed)
        dogDistinctiveFeatures = try container.decode(String.self, forKey: .dogDistinctiveFeatures)
        dogMicrochipNumber = try container.decode(String.self, forKey: .dogMicrochipNumber)
        dogMicrochipSupplier = try container.decode(String.self, forKey: .dogMicrochipSupplier)
        dogStolen = try container.decode(Bool.self, forKey: .dogStolen)
        dogImage = try container.decode(Data.self, forKey: .dogImage)
        dogIncident = try container.decode([WalkUpdate].self, forKey: .dogIncident)
    }
}
