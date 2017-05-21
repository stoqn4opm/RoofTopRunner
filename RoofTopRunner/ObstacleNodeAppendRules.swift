//
//  ObstacleNodeAppendRules.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/20/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation

//MARK: Protocol ObstacleNodeAppendRule

protocol ObstacleNodeAppendRule {
    func shouldAppend(_ obstacle: ObstacleNode, after oldObstacles:[ObstacleNode]) -> Bool
}

//MARK: - Append Rules

struct NoMoreThanFourTrapsRule: ObstacleNodeAppendRule {
    
    internal func shouldAppend(_ obstacle: ObstacleNode, after oldObstacles: [ObstacleNode]) -> Bool {
        
        if obstacle.height == .noObstacle {
            return !lastObstaclesWereTraps(last: oldObstacles, checkLast: 3)
        } else {
            return true
        }
    }
    
    func lastObstaclesWereTraps(last obstacles: [ObstacleNode], checkLast count: Int) -> Bool {
        
        guard obstacles.count >= count else { return false }
        let lastObstacles = obstacles.reversed()[0..<count]
        
        var allLastAreTraps = true
        for obstacle in lastObstacles {
            if obstacle.height != .noObstacle {
                allLastAreTraps = false
                break
            }
        }
        
        return allLastAreTraps
    }
}
