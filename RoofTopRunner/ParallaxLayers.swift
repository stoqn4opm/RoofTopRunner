//
//  ParallaxLayers.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/14/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

extension ParallaxBackgroundNode {
 static let layer1Name = "ParallaxLayer1"
}

extension SKSpriteNode {

    static func parallaxLayer(OfDepth depth: Int) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: "parallax-layer\(depth)")
        sprite.name = ParallaxBackgroundNode.layer1Name
        sprite.anchorPoint = .normalizedLowerLeft
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size, center: CGPoint(x: sprite.size.width / 2, y: sprite.size.height / 2))
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.collisionBitMask = 0
        sprite.physicsBody?.categoryBitMask = 0
        sprite.zPosition = -CGFloat(depth)
        
        switch depth {
        case 1:
            sprite.physicsBody?.contactTestBitMask = ParallaxBackgroundNode.layer1BitMask
        case 2:
            sprite.physicsBody?.contactTestBitMask = ParallaxBackgroundNode.layer2BitMask
        case 3:
            sprite.physicsBody?.contactTestBitMask = ParallaxBackgroundNode.layer3BitMask
        case 4:
            sprite.physicsBody?.contactTestBitMask = ParallaxBackgroundNode.layer4BitMask
        case 5:
            sprite.physicsBody?.contactTestBitMask = ParallaxBackgroundNode.layer5BitMask
        default:
            break
        }
        
        return sprite
    }
}
