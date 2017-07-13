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
//    case four = 4
    
    // keep this property ip to date with the count of cases
    static var count: Int { return 4 }
}

//MARK: - ObstacleNode Implementation

class ObstacleNode: SKNode {
    
    //MARK: - Static Settings
    
    static let obstacleName = "Obstacle"
    static let holeName = "Hole"
    static let width: CGFloat = UIScreen.main.bounds.width / 3.70
    static let height: CGFloat = UIScreen.main.bounds.height * UIScreen.main.scale / 2.5 / 3.0
    
    static var categoryBitMask: UInt32                 = 0b0000001000000
    static var markerObjectBitMask: UInt32             = 0b0000010000000
    static var markerObjectCollisionBitMask: UInt32    = 0b0000100000000
    static fileprivate var collisionBitMask: UInt32    = 0b0001000000000
    
    
    //MARK: - Properties
    var textureName: [String]?
    let height: ObstacleHeight
    
    //MARK: - Initializers
    
    init(withHeight obstacleHeight: ObstacleHeight, textureName: [String]?) {
        height = obstacleHeight
        self.textureName = textureName
        super.init()
        name = obstacleHeight == .noObstacle ? ObstacleNode.holeName : ObstacleNode.obstacleName
        if self.textureName != nil {
            prepareUI(forHeight: obstacleHeight)
        }
        preparePhysics(forHeight: obstacleHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(sameAs obstacleNode: ObstacleNode) {
        self.init(withHeight: obstacleNode.height, textureName: obstacleNode.textureName)
    }
}

//MARK: - Setting Textures 

extension ObstacleNode {
    func applyTextures(_ textureName: [String]?) {
        self.textureName = textureName
        prepareUI(forHeight: height)
    }
}

//MARK: - Internal Preparation

extension ObstacleNode {
    
    fileprivate func textureForHeight(_ height: Int) -> SKTexture? {
        guard let textureName = self.textureName else { return nil }
        guard height < textureName.count else { return nil }
        let texture = SKTexture(imageNamed: textureName[height])
        texture.filteringMode = .nearest
        return texture
    }
    
    fileprivate func cleanUpSpritesIfNeeded() {
        for child in children {
            let obstacle = child as? ObstacleNode
            obstacle?.removeFromParent()
        }
    }
    
    fileprivate func prepareUI(forHeight obstacleHeight: ObstacleHeight) {
        
        cleanUpSpritesIfNeeded()
        
        for i in 0..<obstacleHeight.rawValue {
            let spriteBlock = SKSpriteNode(texture: textureForHeight(i))
            spriteBlock.size = CGSize(width: ObstacleNode.width, height: ObstacleNode.height)
            addChild(spriteBlock)
            spriteBlock.position = CGPoint(x: position.x, y: position.y + CGFloat(i) * ObstacleNode.height)
            spriteBlock.anchorPoint = .normalizedLowerLeft
        }
    }
    
    fileprivate func preparePhysics(forHeight obstacleHeight: ObstacleHeight) {
        
        var physicsRectHeight: CGFloat = 10
        if obstacleHeight != .noObstacle {
            physicsRectHeight = CGFloat(obstacleHeight.rawValue) * ObstacleNode.height
        }
        
        let physicsRect = CGSize(width: ObstacleNode.width, height: physicsRectHeight)
        let physicsRectCenter = CGPoint(x: physicsRect.scaled(at: 0.5).width, y: physicsRect.scaled(at: 0.5).height)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: physicsRect, center: physicsRectCenter)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = ObstacleNode.categoryBitMask
        self.physicsBody?.contactTestBitMask = ObstacleNode.markerObjectBitMask
        self.physicsBody?.collisionBitMask = ObstacleNode.collisionBitMask
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 0.0

    }
}
