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
    
    // keep this property ip to date with the count of cases
    static var count: Int { return 5 }
}

//MARK: - ObstacleNode Implementation

class ObstacleNode: SKNode {
    
    //MARK: - Static Settings
    
    static let obstacleName = "Obstacle"
    static let width = 100
    
    static var categoryBitMask: UInt32                 = 0b0000001000000
    static var markerObjectBitMask: UInt32             = 0b0000010000000
    static var markerObjectCollisionBitMask: UInt32    = 0b0000100000000
    static fileprivate var collisionBitMask: UInt32    = 0b0001000000000
    
    
    //MARK: - Properties
    
    let height: ObstacleHeight
    
    //MARK: - Initializers
    
    init(withHeight obstacleHeight: ObstacleHeight, textureName: String?) {
        height = obstacleHeight
        super.init()
        name = ObstacleNode.obstacleName
        prepareUI(forHeight: obstacleHeight, texture: textureName)
        preparePhysics(forHeight: obstacleHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        var physicsRectHeight = 10
        if obstacleHeight != .noObstacle {
            physicsRectHeight = obstacleHeight.rawValue * ObstacleNode.width
        }
        
        let physicsRect = CGSize(width: ObstacleNode.width, height: physicsRectHeight)
        let physicsRectCenter = CGPoint(x: physicsRect.scaled(at: 0.5).width, y: physicsRect.scaled(at: 0.5).height)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: physicsRect, center: physicsRectCenter)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = ObstacleNode.categoryBitMask
        self.physicsBody?.contactTestBitMask = ObstacleNode.markerObjectBitMask
        self.physicsBody?.collisionBitMask = ObstacleNode.collisionBitMask
    }
}
