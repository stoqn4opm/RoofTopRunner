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
    static let width = 100

    convenience init?(withHeight obstacleHeight: ObstacleHeight, textureName: String?) {
        guard obstacleHeight != .noObstacle else { return nil }
        
        self.init()
        
        for i in 0..<obstacleHeight.rawValue {
            let spriteBlock = SKSpriteNode(imageNamed: textureName ?? "redbox")
            spriteBlock.size = CGSize(width: ObstacleNode.width, height: ObstacleNode.width)
            self.addChild(spriteBlock)
            spriteBlock.position = CGPoint(x: self.position.x, y: self.position.y + CGFloat(i * ObstacleNode.width))
            spriteBlock.anchorPoint = .normalizedLowerLeft
            
            let physicsRect = spriteBlock.size.scaled(at: 0.9)
            let delta = physicsRect.deltaInRegardsTo(spriteBlock.size)
            spriteBlock.physicsBody = SKPhysicsBody(rectangleOf: physicsRect, center:CGPoint(x: (delta.width + physicsRect.width) / 2, y: (delta.height + physicsRect.height) / 2))
            spriteBlock.physicsBody?.affectedByGravity = false
            spriteBlock.physicsBody?.contactTestBitMask = 2
            spriteBlock.physicsBody?.collisionBitMask = UInt32(Double(i).truncatingRemainder(dividingBy: 10))
        }
    }
}
