//
//  Utils.swift
//  Howl
//
//  Created by apple on 18/10/23.
//

import Foundation

func generateRandomString(length: Int) -> String {
    let allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    var randomString = ""
    
    for _ in 1...length {
        let randomIndex = Int.random(in: 0..<allowedChars.count)
        let char = allowedChars[allowedChars.index(allowedChars.startIndex, offsetBy: randomIndex)]
        randomString.append(char)
    }
    
    return randomString
}
