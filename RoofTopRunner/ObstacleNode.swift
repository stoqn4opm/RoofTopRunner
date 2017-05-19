//
//  ObstacleNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/15/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

//MARK: - Supported Obstacle Heights

enum ObstacleHeight: Int { // case's rawValue times the ObstacleNode.width
    
    case noObstacle = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
}

//MARK: - ObstacleNode Implementation

class ObstacleNode: SKNode {
    
    //MARK: - Static Settings
    
    static let width = 100
    
    static var categoryBitMask: UInt32                  = 0b0000001000000
    static var removalObjectBitMask: UInt32             = 0b0000010000000
    static var removalObjectCollisionBitMask: UInt32    = 0b0000100000000
    
    static fileprivate var collisionBitMaskCategoriesCount: UInt32 = 4
    static fileprivate var collisionBitMaskHelper: UInt32 = 0
    
    
    //MARK: - Initializers
    
    convenience init?(withHeight obstacleHeight: ObstacleHeight, textureName: String?) {
        guard obstacleHeight != .noObstacle else { return nil }
        
        self.init()
        name = ObstaclesLayerNode.obstacleName
        prepareUI(forHeight: obstacleHeight, texture: textureName)
        preparePhysics(forHeight: obstacleHeight)
    }
}

//MARK: - Internal Preparation

extension ObstacleNode {
    
    fileprivate func prepareUI(forHeight obstacleHeight: ObstacleHeight, texture textureName: String?) {
        for i in 0..<obstacleHeight.rawValue {
            let spriteBlock = SKSpriteNode(imageNamed: textureName ?? "redbox")
            spriteBlock.size = CGSize(width: ObstacleNode.width, height: ObstacleNode.width)
            self.addChild(spriteBlock)
            spriteBlock.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(i * ObstacleNode.width))
            spriteBlock.anchorPoint = .normalizedLowerLeft
        }
    }
    
    fileprivate func preparePhysics(forHeight obstacleHeight: ObstacleHeight) {
        
        let physicsRect = CGSize(width: ObstacleNode.width, height: obstacleHeight.rawValue * ObstacleNode.width)
        let physicsRectCenter = CGPoint(x: physicsRect.scaled(at: 0.5).width, y: physicsRect.scaled(at: 0.5).height)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: physicsRect, center: physicsRectCenter)
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = ObstacleNode.categoryBitMask
        self.physicsBody?.contactTestBitMask = ObstacleNode.removalObjectBitMask
        
        self.physicsBody?.collisionBitMask = ObstacleNode.collisionBitMaskHelper
        ObstacleNode.collisionBitMaskHelper += 1
        if ObstacleNode.collisionBitMaskHelper == ObstacleNode.collisionBitMaskCategoriesCount {
           ObstacleNode.collisionBitMaskHelper = 0
        }
        
    }
}
