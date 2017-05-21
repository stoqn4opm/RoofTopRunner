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
    let obstacleAppender = ObstacleNodeAppender()
    
    //MARK: - Initializers
    
    init(withSize size: CGSize) {
        self.size = size
        super.init()
        placeObstacleSpawnMarker()
        placeObstacleRemoveMarker()
        subscribeToNotifications()
        
        name = ObstaclesLayerNode.obstacleLayerName
        let newObstacle = obstacleAppender.next
        self.addChild(newObstacle)
        newObstacle.position = CGPoint(x: self.position.x + self.size.width - CGFloat(ObstacleNode.width), y: self.position.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unsubscribeToNotifications()
    }
}

extension ObstaclesLayerNode {
    func update(_ currentTime: TimeInterval) {
        for child in self.children {
            if child.name == ObstacleNode.obstacleName {
                child.position.x -= 40
            }
        }
    }
}

//MARK: - Marker Logic

extension ObstaclesLayerNode {
    
    func placeObstacleRemoveMarker() {
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
    
    func placeObstacleSpawnMarker() {
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

//MARK: - Notifications Handling

extension ObstaclesLayerNode {
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(performEnterForegroundCleanUp), name: Notification.Name.applicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareForBackground), name: Notification.Name.applicationDidEnterBackground, object: nil)
    }
    
    func unsubscribeToNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.applicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.applicationDidEnterBackground, object: nil)
    }
    
    func performEnterForegroundCleanUp() {
        guard let removeMarker = self.childNode(withName: ObstaclesLayerNode.removeMarkerName) as? SKSpriteNode else { return }
        
        for obstacle in self.children {
            if obstacle.name == ObstacleNode.obstacleName {
                obstacle.removeAllActions()
                
                if removeMarker.position.x + removeMarker.size.width >= obstacle.position.x {
                    obstacle.removeFromParent()
                }
            }
        }
    }
    
    func prepareForBackground() {
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
        if contact.bodyA.node?.name == ObstaclesLayerNode.spawnMarkerName && contact.bodyB.node?.name == ObstacleNode.obstacleName {
            let newObstacle = obstacleAppender.next
            newObstacle.position = CGPoint(x: self.position.x + self.size.width - CGFloat(ObstacleNode.width), y: self.position.y)
            self.addChild(newObstacle)
        } else if contact.bodyA.node?.name == ObstacleNode.obstacleName && contact.bodyB.node?.name == ObstaclesLayerNode.spawnMarkerName {
            let newObstacle = obstacleAppender.next
            newObstacle.position = CGPoint(x: self.position.x + self.size.width - CGFloat(ObstacleNode.width), y: self.position.y)
            self.addChild(newObstacle)
        }
    }
}
