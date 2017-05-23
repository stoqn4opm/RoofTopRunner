//
//  ObstaclesLayerNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/15/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class ObstaclesLayerNode: SKNode {
    
    static let removeMarkerName = "RemoveMarker"
    static let spawnMarkerName = "SpawnMarker"
    
    static let obstacleLayerName = "ObstacleLayer"
    
    //MARK: - Properties
    
    let size: CGSize
    fileprivate var lastPlacedObstacle: ObstacleNode?
    fileprivate let obstacleAppender = ObstacleNodeAppender()
    fileprivate let obstacleNodeAppenderController: ObstacleNodeAppenderController
    
    fileprivate var timeOfLastUpdate: TimeInterval?
    fileprivate var timeOfSceneLoad: TimeInterval?

    
    fileprivate var _rate: CGFloat = 1 // dependant of the width of spawnMarker. Max tested that code can handle: 30
    fileprivate var rate: CGFloat {
        get {
            return _rate
        }
        set {
            if newValue < 30 {
                _rate = newValue
                updateSpeedLabelIfNeeded(speed: newValue)
            }
        }
    }
    
    //MARK: - Initializers
    
    init(withSize size: CGSize) {
        self.size = size
        obstacleNodeAppenderController = ObstacleNodeAppenderController(with: obstacleAppender)
        super.init()
        initialPreparation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialPreparation() {
        placeObstacleSpawnMarker()
        placeObstacleRemoveMarker()
        name = ObstaclesLayerNode.obstacleLayerName
        
        let newObstacle = obstacleAppender.next
        self.addChild(newObstacle)
        newObstacle.position = CGPoint(x: self.position.x + self.size.width - CGFloat(ObstacleNode.width), y: self.position.y)
    }
}

//MARK: - Obstacle Movement

extension ObstaclesLayerNode {
    func update(_ currentTime: TimeInterval) {
        moveChildren()
        updateSpeedRate(forCurrentTime: currentTime)
    }
    
    func moveChildren() {
        for child in self.children {
            if child.name == ObstacleNode.obstacleName {
                child.position.x -= _rate
            }
        }
    }
    
    func updateSpeedRate(forCurrentTime currentTime: TimeInterval) {
        if let lastUpdateTime = timeOfLastUpdate, let initialTime = timeOfSceneLoad {
            
            let timeSinceLastUpdate = currentTime - lastUpdateTime
            
            if timeSinceLastUpdate > 0.1 {
                let timePassed = currentTime - initialTime
                self.rate = obstacleNodeAppenderController.speedRate(forPassedTime: timePassed)
                timeOfLastUpdate = currentTime
            }
        } else {
            timeOfLastUpdate = currentTime
            timeOfSceneLoad = currentTime
        }
    }
}

//MARK: - Obstacles Spawning/Removing

extension ObstaclesLayerNode {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == ObstaclesLayerNode.removeMarkerName && contact.bodyB.node?.name == ObstacleNode.obstacleName {
            contact.bodyB.node?.removeFromParent()
        } else if contact.bodyA.node?.name == ObstacleNode.obstacleName && contact.bodyB.node?.name == ObstaclesLayerNode.removeMarkerName {
            contact.bodyA.node?.removeFromParent()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.node?.name == ObstaclesLayerNode.spawnMarkerName && contact.bodyB.node?.name == ObstacleNode.obstacleName) ||
            (contact.bodyA.node?.name == ObstacleNode.obstacleName && contact.bodyB.node?.name == ObstaclesLayerNode.spawnMarkerName) {

            if let previousObstacle = lastPlacedObstacle {
                
                let newObstacle = obstacleAppender.next
                newObstacle.position = CGPoint(x: previousObstacle.position.x + CGFloat(ObstacleNode.width), y: previousObstacle.position.y)
                self.addChild(newObstacle)
                lastPlacedObstacle = newObstacle
            } else {
                let newObstacle = obstacleAppender.next
                newObstacle.position = CGPoint(x: self.position.x + self.size.width - CGFloat(ObstacleNode.width), y: self.position.y)
                self.addChild(newObstacle)
                lastPlacedObstacle = newObstacle
            }
        }
    }
}

//MARK: - Marker Logic

extension ObstaclesLayerNode {
    
    fileprivate func placeObstacleRemoveMarker() {
        let removeMarker = SKSpriteNode(color: .green, size: CGSize(width: ObstacleNode.width, height: ObstacleNode.width))
        self.addChild(removeMarker)
        removeMarker.position = CGPoint(x: self.position.x + CGFloat(ObstacleNode.width) / 2, y: self.position.y + CGFloat(ObstacleNode.width) / 2)
        removeMarker.name = ObstaclesLayerNode.removeMarkerName
        removeMarker.physicsBody = SKPhysicsBody(rectangleOf: removeMarker.size, center: .zero)
        removeMarker.physicsBody?.affectedByGravity = false
        removeMarker.physicsBody?.contactTestBitMask = ObstacleNode.categoryBitMask
        removeMarker.physicsBody?.collisionBitMask = ObstacleNode.markerObjectCollisionBitMask
        removeMarker.physicsBody?.categoryBitMask = ObstacleNode.markerObjectBitMask
    }
    
    fileprivate func placeObstacleSpawnMarker() {
        let spawnMarker = SKSpriteNode(color: .gray, size: CGSize(width: ObstacleNode.width, height: ObstacleNode.width))
        self.addChild(spawnMarker)
        spawnMarker.position = CGPoint(x: self.position.x + self.size.width - CGFloat(ObstacleNode.width) / 2, y: self.position.y + CGFloat(ObstacleNode.width) / 2)
        spawnMarker.name = ObstaclesLayerNode.spawnMarkerName
        spawnMarker.physicsBody = SKPhysicsBody(rectangleOf: spawnMarker.size, center: .zero)
        spawnMarker.physicsBody?.affectedByGravity = false
        spawnMarker.physicsBody?.contactTestBitMask = ObstacleNode.categoryBitMask
        spawnMarker.physicsBody?.collisionBitMask = ObstacleNode.markerObjectCollisionBitMask
        spawnMarker.physicsBody?.categoryBitMask = ObstacleNode.markerObjectBitMask
    }
}

//MARK: - Current Rate On Screen

extension ObstaclesLayerNode {
    
    func showCurrentRateOnScreen(_ currentRate: Bool) {
        self.childNode(withName: "speedLabel")?.removeFromParent()
        
        if currentRate {
            let speedLabel = SKLabelNode(text: "speed:")
            speedLabel.name = "speedLabel"
            self.addChild(speedLabel)
            speedLabel.position = CGPoint(x: 140, y: size.height - 80)
        }
    }
    
    fileprivate func updateSpeedLabelIfNeeded(speed: CGFloat) {
        let speedLabel = self.childNode(withName: "speedLabel") as? SKLabelNode
        speedLabel?.text = String(format: "speed %.2f", speed)
    }
}
