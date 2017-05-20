//
//  ObstacleNodeAppender.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/20/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation

protocol ObstacleNodeAppendRule {
    func shouldAppend(_ obstacle: ObstacleNode?, after:[ObstacleNode?]) -> Bool
}

class ObstacleNodeAppender {
    
    //MARK: - Global Settings
    
    static let historyObstaclesCount = 10
    
    //MARK: - Properties
    
    fileprivate var obstaclesHistory: [ObstacleNode?] = []
    
    //MARK: Public Interface
    
    var appendRules: [ObstacleNodeAppendRule] = []
    
    var next: ObstacleNode? {
        
        var shouldAppend = true

        repeat {
            
            let obstacle = self.randomObstacle
            
            shouldAppend = true
            for rule in appendRules {
                if rule.shouldAppend(obstacle, after: obstaclesHistory) == false {
                    shouldAppend = false
                    break
                }
            }
            
            if shouldAppend {
                remember(obstacle)
                return obstacle
            }
            
        } while shouldAppend == false
        return nil
    }
    
    private func playPattern() {} // will add the possibility to append specific pattern of obstacles in future
    
}

//MARK: - Random Obstacle Generation

extension ObstacleNodeAppender {
    
    fileprivate var randomObstacle: ObstacleNode? {
        let randomRawHeight = arc4random_uniform(5)
        guard let height = ObstacleHeight(rawValue: Int(randomRawHeight)) else { return nil }
        let obstacle = ObstacleNode(withHeight: height, textureName: nil)
        return obstacle
    }
}

//MARK: - History Managment

extension ObstacleNodeAppender {
    
    fileprivate func remember(_ obstacle: ObstacleNode?) {
        obstaclesHistory.append(obstacle)
        if obstaclesHistory.count >= ObstacleNodeAppender.historyObstaclesCount {
            obstaclesHistory.removeFirst()
        }
    }
}
