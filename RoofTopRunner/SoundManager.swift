//
//  SoundManager.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 8/19/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import AVFoundation

class SoundManager {
    
    fileprivate var sfxPlayer: AVAudioPlayer?
    fileprivate var bgmPlayer: AVAudioPlayer?
    
    //MARK: Shared Instance
    
    static let shared : SoundManager = {
        let instance = SoundManager()
        return instance
    }()
}

//MARK: BGM

extension SoundManager {
    
}


//MARK: - SFX

extension SoundManager {
    public func playSoundEffectNamed(_ filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "wav") else {
            print("Could not find file: \(filename)")
            return
        }
        
        sfxPlayer = try? AVAudioPlayer(contentsOf: url)
        sfxPlayer?.numberOfLoops = 0
        sfxPlayer?.prepareToPlay()
        sfxPlayer?.play()
        
        if sfxPlayer == nil { print("Could not create sfx audio player") }
    }
}
