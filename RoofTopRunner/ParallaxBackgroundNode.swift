//
//  ParallaxBackgroundNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/13/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class ParallaxBackgroundNode: SKNode {

    //MARK: Static Properties
    
    static let parallaxBackgroundName = "ParallaxBackgroundName"
    
    static let removeMarkerName = "BackgroundRemoveMarker"
    static let spawnMarkerName = "BackgroundSpawnMarker"
    
    static let parallaxLayerName = "ParallaxLayerName"
    
    static var layer1BitMask: UInt32                    = 0b00001000000000
    static var layer2BitMask: UInt32                    = 0b00010000000000
    static var layer3BitMask: UInt32                    = 0b00100000000000
    static var layer4BitMask: UInt32                    = 0b01000000000000
    static var layer5BitMask: UInt32                    = 0b10000000000000
    static var markerObjectBitMask: UInt32              = 0b11111000000000

    //MARK: - Properties
    
    fileprivate var rate: CGFloat = 1 // controlled by the speed of obstacle layer
    
    //MARK: - Initializer
    
    override init() {
        super.init()
        name = ParallaxBackgroundNode.parallaxBackgroundName
        prepareSpawnMarker()
        prepareRemoveMarker()
        placeInitialLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Helpers

extension ParallaxBackgroundNode {
    
    var screenSize: CGSize {
        return GameManager.shared.skView.frame.size.scaled()
    }
}

//MARK: - Spawn/Remove Markers

extension ParallaxBackgroundNode {
    
    func prepareSpawnMarker() {
        let spawnMarker = SKSpriteNode(color: .gray, size: CGSize(width: 300, height: 500))
        spawnMarker.anchorPoint = .normalizedLowerLeft
        self.addChild(spawnMarker)
        spawnMarker.position = CGPoint(x: self.position.x + screenSize.width + 200, y: 0) // 2600 is the length on the longest layer
        spawnMarker.name = ParallaxBackgroundNode.spawnMarkerName
        spawnMarker.physicsBody = SKPhysicsBody(rectangleOf: spawnMarker.size,
                                                center: CGPoint(x: spawnMarker.size.width / 2, y: spawnMarker.size.height / 2))
        spawnMarker.physicsBody?.affectedByGravity = false
        spawnMarker.physicsBody?.contactTestBitMask = ParallaxBackgroundNode.markerObjectBitMask
        spawnMarker.physicsBody?.collisionBitMask = 0
        spawnMarker.physicsBody?.categoryBitMask = ParallaxBackgroundNode.markerObjectBitMask
    }
    
    func prepareRemoveMarker() {
        let removeMarker = SKSpriteNode(color: .green, size: CGSize(width: 300, height: 500))
        removeMarker.anchorPoint = .normalizedLowerLeft
        self.addChild(removeMarker)
        removeMarker.position = CGPoint(x: self.position.x - 6000, y: 0)  // 2600 is the length on the longest layer
        removeMarker.name = ParallaxBackgroundNode.removeMarkerName
        removeMarker.physicsBody = SKPhysicsBody(rectangleOf: removeMarker.size,
                                                 center: CGPoint(x: removeMarker.size.width / 2, y: removeMarker.size.height / 2))
        removeMarker.physicsBody?.affectedByGravity = false
        removeMarker.physicsBody?.contactTestBitMask = ParallaxBackgroundNode.markerObjectBitMask
        removeMarker.physicsBody?.collisionBitMask = 0
        removeMarker.physicsBody?.categoryBitMask = ParallaxBackgroundNode.markerObjectBitMask
    }
}

//MARK: - Layers Preparation

extension ParallaxBackgroundNode {
    
    func placeInitialLayers() {
        guard let endX = childNode(withName: ParallaxBackgroundNode.spawnMarkerName)?.position.x else { return }
        guard let startX = childNode(withName: ParallaxBackgroundNode.removeMarkerName)?.position.x else { return }
        
        for depth in 1...5 {
            
            let layerSprite = SKSpriteNode.parallaxLayer(OfDepth: depth)
            for i in 0...Int((endX - startX) / layerSprite.size.width) {
                let layer = layerSprite.copy() as! SKSpriteNode
                addChild(layer)
                layer.position = CGPoint(x: CGFloat(i) * layer.size.width, y: 0)
            }
        }
    }
}

//MARK: - Spawn/Remove Logic

extension ParallaxBackgroundNode {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == ParallaxBackgroundNode.removeMarkerName && contact.bodyB.node?.name == ParallaxBackgroundNode.parallaxLayerName) {
            contact.bodyB.node?.removeFromParent()
        } else if (contact.bodyA.node?.name == ParallaxBackgroundNode.parallaxLayerName && contact.bodyB.node?.name == ParallaxBackgroundNode.removeMarkerName) {
            contact.bodyA.node?.removeFromParent()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.node?.name == ParallaxBackgroundNode.spawnMarkerName && contact.bodyB.node?.name == ParallaxBackgroundNode.parallaxLayerName) {
            guard let newSprite = contact.bodyB.node?.copy() as? SKSpriteNode else { return }
            newSprite.position = CGPoint(x: newSprite.position.x + newSprite.size.width, y: newSprite.position.y)
            addChild(newSprite)
        } else if (contact.bodyA.node?.name == ParallaxBackgroundNode.parallaxLayerName && contact.bodyB.node?.name == ParallaxBackgroundNode.spawnMarkerName) {
            guard let newSprite = contact.bodyA.node?.copy() as? SKSpriteNode else { return }
            newSprite.position = CGPoint(x: newSprite.position.x + newSprite.size.width, y: newSprite.position.y)
            addChild(newSprite)
        }
    }
}

//MARK: - Layers Movement

extension ParallaxBackgroundNode {
    func update(_ currentTime: TimeInterval) {
        guard let scene = scene as? EndlessLevelScene else { return }
        if scene.state == .running {
            moveChildren()
            updateSpeedRate()
        }
    }
    
    func moveChildren() {
        for child in self.children {
            if child.name == ParallaxBackgroundNode.parallaxLayerName {
                guard let collisionBitmask = child.physicsBody?.contactTestBitMask else { continue }
                switch collisionBitmask {
                case ParallaxBackgroundNode.layer1BitMask:
                    child.position.x -= rate
                case ParallaxBackgroundNode.layer2BitMask:
                    child.position.x -= rate / 2
                case ParallaxBackgroundNode.layer3BitMask:
                    child.position.x -= rate / 4
                case ParallaxBackgroundNode.layer4BitMask:
                    child.position.x -= rate / 8
//                case ParallaxBackgroundNode.layer5BitMask: // don't move the background with the moon
//                    child.position.x -= _rate / 16
                default:
                    break
                }
            }
        }
    }
    
    func updateSpeedRate() {
        guard let obstacleLayer = self.scene?.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode else { return }
        rate = obstacleLayer.rate
    }
}
