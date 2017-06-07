//
//  EndlessLevelScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit
import SwiftyJSON

//MARK: Scene Loading

class EndlessLevelScene: SKScene {
    
    override func sceneDidLoad() {
        self.anchorPoint = .normalizedLowerLeft
        self.physicsWorld.contactDelegate = self
        
        loadObstacleLayer()
        
        let mainChar = MainCharacterNode.basic
        self.addChild(mainChar)
        mainChar.position = CGPoint(x: 300, y: 300)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        MainCharacterNodeJumpBehaviour.makeStartEvent()
        MainCharacterNodeDownwardJumpBehaviour.makeStartEvent()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        MainCharacterNodeJumpBehaviour.makeEndEvent()
    }
}

//MARK: - Obstacles Layer

extension EndlessLevelScene {
    func loadObstacleLayer() {

        let obstacleLayer = ObstaclesLayerNode(withSize: self.size)
        self.addChild(obstacleLayer)
        obstacleLayer.showCurrentRateOnScreen(true)
    }
}

//MARK: - Main Loop

extension EndlessLevelScene {
    override func update(_ currentTime: TimeInterval) {
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.update(currentTime)
        
        let mainCharacter = self.childNode(withName: MainCharacterNode.characterName) as? MainCharacterNode
        mainCharacter?.behaviourController.update(currentTime)
    }
}

//MARK: - Physics CallBacks

extension EndlessLevelScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.didBegin(contact)
        
        let mainCharacter = self.childNode(withName: MainCharacterNode.characterName) as? MainCharacterNode
        mainCharacter?.didBegin(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.didEnd(contact)
        
        let mainCharacter = self.childNode(withName: MainCharacterNode.characterName) as? MainCharacterNode
        mainCharacter?.didEnd(contact)
    }
}
