//
//  DogsWalkModel.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation
import UIKit


struct WalkUpdate: Codable {
    
    // Variables
    var id: String!
    var longitude: String!
    var latitude: String!
    var speed: String!
    var course: String!
    var date: String!
    var time: String!
    var battery: String!
    var status: String!
    var w3wWords: String!
    var w3wURL: String!
    var state: String!
    var device: String!
    var flag: String!
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case longitude
        case latitude
        case speed
        case device
        case course
        case date
        case time
        case battery
        case status
        case w3wWords
        case w3wURL
        case state
        case flag
    }
    
    init(
        walkID: String,
        walkLongitude: String,
        walkLatitude: String,
        walkSpeed: String,
        walkCourse: String,
        walkDate: String,
        walkTime: String,
        walkBattery: String,
        walkStatus: String,
        walkW3WWords: String,
        walkW3WURL: String,
        states: String,
        devices: String,
        flags: String
    ) {
        
        id = walkID
        longitude = walkLongitude
        latitude = walkLatitude
        speed = walkSpeed
        course = walkCourse
        date = walkDate
        time = walkTime
        battery = walkBattery
        status = walkStatus
        w3wWords = walkW3WWords
        w3wURL = walkW3WURL
        state = states
        device = devices
        flag = flags
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(speed, forKey: .speed)
        try container.encode(course, forKey: .course)
        try container.encode(date, forKey: .date)
        try container.encode(time, forKey: .time)
        try container.encode(battery, forKey: .battery)
        try container.encode(status, forKey: .status)
        try container.encode(w3wWords, forKey: .w3wWords)
        try container.encode(w3wURL, forKey: .w3wURL)
        try container.encode(state, forKey: .state)
        try container.encode(device, forKey: .device)
        try container.encode(flag, forKey: .flag)
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        longitude = try container.decode(String.self, forKey: .longitude)
        latitude = try container.decode(String.self, forKey: .latitude)
        speed = try container.decode(String.self, forKey: .speed)
        course = try container.decode(String.self, forKey: .course)
        date = try container.decode(String.self, forKey: .date)
        time = try container.decode(String.self, forKey: .time)
        battery = try container.decode(String.self, forKey: .battery)
        status = try container.decode(String.self, forKey: .status)
        w3wWords = try container.decode(String.self, forKey: .w3wWords)
        w3wURL = try container.decode(String.self, forKey: .w3wURL)
        state = try container.decode(String.self, forKey: .state)
        device = try container.decode(String.self, forKey: .device)
        flag = try container.decode(String.self, forKey: .flag)
    }
}
struct WalkFetch {
    var walkID: String
    var walkLongitude: String
    var walkLatitude: String
    var walkSpeed: String
    var walkCourse: String
    var walkDate: String
    var walkTime: String
    var walkBattery: String
    var walkStatus: String
    var walkW3WWords: String
    var walkW3WURL: String
    var flag: String
}
