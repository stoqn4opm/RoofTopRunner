//
//  ObstacleNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/15/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

enum ObstacleHeight: Int {
    case noObstacle = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
}

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
        }
    }
}
