//
//  SoundManager.swift
//  Just Move Simple
//
//  Created by Peter Farrell on 02/05/2020.
//  Copyright © 2020 App Intelligence Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class SoundManager: NSObject, AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate {
    
    //MARK: Singleton Code
    static let sharedInstance : SoundManager = {
        
        let instance = SoundManager()
        return instance
    }()
    
    //MARK: SoundManager variables
    let kDeepDataLogging = true
    var audioPlayer: AVAudioPlayer!
    var speechOutput: AVSpeechSynthesizer!
    var speechUtterance: AVSpeechUtterance!
    
    //MARK: URL's for sound bytes
    var scannedURL: URL!
    
    //MARK: Speech Output
    var error: NSError?
    var nextSpeechOutputHolder: Array<String>!
    var continuingSpeaking: Bool!
    
    override init() {
        
        super.init()
        
//        if kDeepDataLogging {
//            
//            let allVoices = AVSpeechSynthesisVoice.speechVoices()
//            
//            for voice in allVoices {
//                
//                print("Voice Name: \(voice.name) Identifier: \(voice.identifier) Quality: \((voice.quality).rawValue))")
//            }
//        }
        
        self.speechOutput = AVSpeechSynthesizer()
        self.speechOutput.delegate = self
        
        self.audioPlayer = AVAudioPlayer()
        
        self.nextSpeechOutputHolder = []
        
        self.continuingSpeaking = false
    }
    
    func playSiren(index: Int, volume: Float, testing: Bool) {
        
        let fileName = "Siren\(index)"
        
        let siren = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: siren)
            audioPlayer.volume = volume // 30% volume
            
            switch testing {
                
            case true:
                audioPlayer.numberOfLoops = 3 // Infinite loop
            case false:
                audioPlayer.numberOfLoops = -1 // Infinite loop
            }
            audioPlayer.play() // play the sound
        } catch let error1 as NSError {
            error = error1
            print(error!)
        }
    }
    
    func stopSiren() {
        
        if audioPlayer != nil {
            
            audioPlayer.stop()
        }
    }
    
    func outputSpeechFromText(_ textToRead: String) {
        
        if self.speechOutput.isSpeaking {
            
            self.speechOutput.stopSpeaking(at: .immediate)
        }
        
        self.speechUtterance = AVSpeechUtterance(string: textToRead)
        //self.speechUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-GB_compact")
        self.speechUtterance.rate = 0.5
        self.speechUtterance.pitchMultiplier = 1.05
        
        self.speechOutput.speak(self.speechUtterance)
    }
    
    func addTextToBeSpokenNext(_ nextSpeechOutput: String) {
        
        if !self.speechOutput.isSpeaking {
            
            outputSpeechFromText(nextSpeechOutput)
        } else {
            
            nextSpeechOutputHolder.append(nextSpeechOutput)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        
        print("Speech Did Pause")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        
        print("Speech Did Cancel")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        print("Speech Did Start")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        
        print("Speech Did Continue")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        print("Speed Did Finish")
        continuingSpeaking = false // Confirm no more speech output
        
        if nextSpeechOutputHolder.count > 0 { // If there is addiitonal speech to output
            
            self.outputSpeechFromText(nextSpeechOutputHolder.first!) // output the first item to be spoken
            nextSpeechOutputHolder.removeFirst() // remove once output so doesnt get spoken again
            continuingSpeaking = true
        }
    }
}
