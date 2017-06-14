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
    
    fileprivate var timeOfLastUpdate: TimeInterval?
    fileprivate var timeOfSceneLoad: TimeInterval?
    
    
    fileprivate var _rate: CGFloat = 1 // dependant of the width of spawnMarker. Max tested that code can handle: 30
    fileprivate var rate: CGFloat {
        get {
            return _rate
        }
        set {
            if newValue < ObstaclesLayerNode.speedRateLimiter {
                _rate = newValue
            }
        }
    }
    
    //MARK: - Initializer
    
    init(withLayers layers: [String]) {
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
        spawnMarker.position = CGPoint(x: self.position.x + screenSize.width - 1 * spawnMarker.size.width, y: 0)
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
        removeMarker.position = CGPoint(x: self.position.x + 0 * removeMarker.size.width, y: 0)
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
    
    func prepareFirstLayer() {
        
    }
    
}

//MARK: - Spawn/Remove Logic

extension ParallaxBackgroundNode {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == ParallaxBackgroundNode.removeMarkerName && contact.bodyB.node?.name == ParallaxBackgroundNode.layer1Name) {
            contact.bodyB.node?.removeFromParent()
        } else if (contact.bodyA.node?.name == ParallaxBackgroundNode.layer1Name && contact.bodyB.node?.name == ParallaxBackgroundNode.removeMarkerName) {
            contact.bodyA.node?.removeFromParent()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.node?.name == ParallaxBackgroundNode.spawnMarkerName && contact.bodyB.node?.name == ParallaxBackgroundNode.layer1Name) {
            guard let newSprite = contact.bodyB.node?.copy() as? SKSpriteNode else { return }
            newSprite.position = CGPoint(x: newSprite.position.x + newSprite.size.width, y: newSprite.position.y)
            addChild(newSprite)
        } else if (contact.bodyA.node?.name == ParallaxBackgroundNode.layer1Name && contact.bodyB.node?.name == ParallaxBackgroundNode.spawnMarkerName) {
            guard let newSprite = contact.bodyA.node?.copy() as? SKSpriteNode else { return }
            addChild(newSprite)
            newSprite.position = CGPoint(x: newSprite.position.x + newSprite.size.width, y: newSprite.position.y)
        }
    }
}

//MARK: - Layers Movement

extension ParallaxBackgroundNode {
    func update(_ currentTime: TimeInterval) {
        guard let scene = scene as? EndlessLevelScene else { return }
        if scene.state == .running {
            moveChildren()
            updateSpeedRate(forCurrentTime: currentTime)
        }
    }
    
    func moveChildren() {
        for child in self.children {
            if child.name == ParallaxBackgroundNode.layer1Name {
                child.position.x -= _rate
            }
        }
    }
    
    func updateSpeedRate(forCurrentTime currentTime: TimeInterval) {
        if let lastUpdateTime = timeOfLastUpdate, let initialTime = timeOfSceneLoad {
            
            let timeSinceLastUpdate = currentTime - lastUpdateTime
            
            if timeSinceLastUpdate > 0.1 {
                let timePassed = currentTime - initialTime
//                self.rate = obstacleNodeAppenderController.speedRate(forPassedTime: timePassed)
                timeOfLastUpdate = currentTime
            }
        } else {
            timeOfLastUpdate = currentTime
            timeOfSceneLoad = currentTime
        }
    }
}
