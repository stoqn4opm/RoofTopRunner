//
//  GameManager.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftyJSON

extension Notification.Name {
    static let applicationWillEnterForeground = Notification.Name("applicationWillEnterForeground")
    static let applicationDidEnterBackground = Notification.Name("applicationDidEnterBackground")
}

class GameManager {
    
    //MARK: Shared Instance
    static let shared : GameManager = {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.ignoresSiblingOrder = true
        
        // various debug options
        skView.showsFPS = true
        skView.showsNodeCount = true
//        skView.showsFields = true
        skView.showsPhysics = true
        
        let instance = GameManager(skView: skView)
        return instance
    }()
    
    //MARK: Local Variable
    var skView : SKView
    
    //MARK: Init
    init(skView : SKView) {
        self.skView = skView
    }
}

//MARK: - Loading Scenes
extension GameManager {
    
    func loadMenuScene() { }
    
    func loadEndlessLevelScene() {
        let endlessScene = EndlessLevelScene(size: skView.frame.size.scaled())
        loadScene(scene: endlessScene)
    }
    
    private func loadScene(scene: SKScene) {
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
}
