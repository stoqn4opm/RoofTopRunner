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
    public func playBackgroundMusicNamed(_ filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "wav") else {
            print("[SoundManager] Could not find file: \(filename)")
            return
        }
        
        bgmPlayer = try? AVAudioPlayer(contentsOf: url)
        bgmPlayer?.numberOfLoops = -1 // loop endlessly
        bgmPlayer?.prepareToPlay()
        bgmPlayer?.play()
        
        if bgmPlayer == nil { print("[SoundManager] Could not create bgm audio player") }
    }
    
    func stopBackgroundMusic() {
        bgmPlayer?.stop()
        if bgmPlayer == nil { print("[SoundManager] Could not stop bgm audio player because its nil") }
    }
    
    func pauseBackgroundMusic() {
        bgmPlayer?.pause()
        if bgmPlayer == nil { print("[SoundManager] Could not pause bgm audio player because its nil") }
    }
    
    func resumeBackgroundMusic() {
        bgmPlayer?.play()
        if bgmPlayer == nil { print("[SoundManager] Could not resume bgm audio player because its nil") }
    }
}


//MARK: - SFX

extension SoundManager {
    public func playSoundEffectNamed(_ filename: String, loop: Bool = false) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "wav") else {
            print("[SoundManager] Could not find file: \(filename)")
            return
        }
        
        sfxPlayer = try? AVAudioPlayer(contentsOf: url)
        sfxPlayer?.numberOfLoops = loop ? -1 : 0
        sfxPlayer?.prepareToPlay()
        sfxPlayer?.play()
        
        if sfxPlayer == nil { print("[SoundManager] Could not create sfx audio player") }
    }
    
    func stopSoundEffect() {
        sfxPlayer?.stop()
        if sfxPlayer == nil { print("[SoundManager] Could not stop sfx audio player because its nil") }
    }
}
