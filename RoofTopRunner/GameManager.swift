//
//  GameManager.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import SpriteKit

enum GameRunMode {
    case prod
    case dev
    case qa
}


class GameManager {
    
    //MARK: Shared Instance
    static let shared : GameManager = {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.ignoresSiblingOrder = true
        
        
        let instance = GameManager(skView: skView)
        
        if instance.runMode == .dev {
            // various debug options
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsFields = true
            skView.showsPhysics = true
        }
        
        return instance
    }()
    
    //MARK: Local Variable
    var skView : SKView
    
    //MARK: Init
    init(skView : SKView) {
        self.skView = skView
    }
    
    var runMode: GameRunMode {
        var result = GameRunMode.prod
        
        #if QA_BUILD
            result = GameRunMode.qa
        #else
            #if DEV_BUILD
                result = GameRunMode.dev
            #endif
        #endif
        
        return result
    }
}

//MARK: - Loading Scenes
extension GameManager {
    
    func loadIntroStoryScene() {
        guard let introStoryScene = SKScene(fileNamed: "IntroStoryScene") else { return }
        loadScene(scene: introStoryScene)
    }
    
    func loadTitleScene() {
        guard let titleScene = SKScene(fileNamed: "TitleScene") else { return }
        loadScene(scene: titleScene)
    }
    
    func loadScratchScene() {
        guard let titleScene = SKScene(fileNamed: "ScratchScene") else { return }
        loadScene(scene: titleScene)
    }
    
    func loadMenuScene() {
        let mainMenuScene = MainMenuScene(size: skView.frame.size.scaled())
        loadScene(scene: mainMenuScene)
    }
    
    func loadEndlessLevelScene() {
        let endlessScene = EndlessLevelScene(size: skView.frame.size.scaled())
        loadScene(scene: endlessScene)
    }
    
    private func loadScene(scene: SKScene) {
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
}
