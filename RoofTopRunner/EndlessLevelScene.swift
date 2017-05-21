//
//  EndlessLevelScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit
import SwiftyJSON

class EndlessLevelScene: SKScene {
    
    override func sceneDidLoad() {
        self.backgroundColor = .blue
        self.anchorPoint = .normalizedLowerLeft
        
        
        let obstaclePage = ObstaclesLayerNode(withSize: self.size)
        self.addChild(obstaclePage)
        
        
        obstaclePage.obstacleAppender.appendRules.append(NoMoreThanFourTrapsRule())
        
        self.physicsWorld.contactDelegate = self
    }
}

extension EndlessLevelScene {
    override func update(_ currentTime: TimeInterval) {
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.update(currentTime)
    }
}

extension EndlessLevelScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.didBegin(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.didEnd(contact)
    }
}
