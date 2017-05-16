//
//  ObstaclePageNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/15/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit
import SwiftyJSON

class ObstaclePageNode: SKNode {
    
    var obstacleModel: JSON
    
    var difficulty: Int {
        return obstacleModel["difficulty"].int ?? Int.max
    }
    
    init(obstacleModel: JSON) {
        self.obstacleModel = obstacleModel
        super.init()
        layoutObstaclePage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layoutObstaclePage() {
        guard let obstacles = obstacleModel["obstacles"].array else { return }
        
        for i in 0..<obstacles.count {
            guard let rawHeight = obstacles[i]["height"].int,
                  let height = ObstacleHeight(rawValue: rawHeight) else { return }
            
            if let obstacleNode = ObstacleNode(withHeight: height, textureName: obstacles[i]["texture"].string) {
                
                self.addChild(obstacleNode)
                obstacleNode.position = CGPoint(x: self.position.x + CGFloat(i * ObstacleNode.width), y: self.position.y)
            }
        }
    }
}
