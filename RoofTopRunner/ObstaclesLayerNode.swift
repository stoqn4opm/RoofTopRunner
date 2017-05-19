//
//  ObstaclesLayerNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/15/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class ObstaclesLayerNode: SKNode {
    
    //MARK: - Properties
    
    let size: CGSize
    fileprivate var spawnTimer: Timer = Timer()
    fileprivate var _rate: TimeInterval = 1
    
    //MARK: - Initializers
    
    init(withSize size: CGSize) {
        self.size = size
        spawnTimer = Timer()
        super.init()
        rate = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Speed Control

extension ObstaclesLayerNode {
    
    var rate: TimeInterval {
        set {
            _rate = newValue
            spawnTimer.invalidate()
            spawnTimer = Timer.scheduledTimer(timeInterval: 1 / _rate, target: self,
                                              selector: #selector(tick), userInfo: nil,
                                              repeats: true)
        }
        get {
            return _rate
        }
    }
}

//MARK: - Internal Logic

extension ObstaclesLayerNode {
    
    @objc fileprivate func tick() {
        appendObstacle()
        for obstacles in self.children {
            obstacles.run(SKAction.moveBy(x: -CGFloat(ObstacleNode.width), y: 0, duration: 1 / rate))
        }
    }
    
    fileprivate func appendObstacle() {
        let height = ObstacleHeight.one
        if let obstacleNode = ObstacleNode(withHeight: height, textureName: "") {
            self.addChild(obstacleNode)
            obstacleNode.position = CGPoint(x: self.position.x - CGFloat(ObstacleNode.width) + size.width, y: self.position.y)
        }
    }
}
