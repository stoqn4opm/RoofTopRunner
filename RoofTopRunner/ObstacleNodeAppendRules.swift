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

struct HoleOrSameAsPreviousRule: ObstacleNodeAppendRule {
    
    internal func shouldAppend(_ obstacle: ObstacleNode, after oldObstacles: [ObstacleNode]) -> Bool {
        
        let lastObstacle = oldObstacles.reversed().first
        
        if lastObstacle != nil {
            if lastObstacle?.height != .noObstacle {
                if obstacle.height == lastObstacle?.height ||
                    obstacle.height == .noObstacle {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }            
        } else {
            if obstacle.height != .noObstacle {
                return true
            } else {
                return false
            }
        }
        
    }
}

struct SameAsPriorToTwoHolesRule: ObstacleNodeAppendRule {

    internal func shouldAppend(_ obstacle: ObstacleNode, after oldObstacles: [ObstacleNode]) -> Bool {


        if lastObstaclesWereTraps(last: oldObstacles, checkLast: 2) {

            guard oldObstacles.count >= 3 else { return true }
            let obstacleBeforeTwoHoles = oldObstacles.reversed()[2]
            
            if obstacle.height == obstacleBeforeTwoHoles.height &&
                obstacleBeforeTwoHoles.height != .noObstacle {
                return true
            } else {
                return false
            }

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

struct NoBiggerHeightDifferenceThanOneAfterHoleRule: ObstacleNodeAppendRule {
    
    internal func shouldAppend(_ obstacle: ObstacleNode, after oldObstacles: [ObstacleNode]) -> Bool {
        
        guard oldObstacles.count >= 2 else { return true }
        let lastObstacle = oldObstacles.reversed()[0]
        let obstaclePriorToLastObstacle = oldObstacles.reversed()[1]
        
        if lastObstacle.height == .noObstacle {
            
            if abs(obstacle.height.rawValue - obstaclePriorToLastObstacle.height.rawValue) <= 1 {
                return true
            } else {
                return false
            }
            
        } else {
            return true
        }
    }
}

struct NoLessThanTwoConsecutiveObstacles: ObstacleNodeAppendRule {
    
    internal func shouldAppend(_ obstacle: ObstacleNode, after oldObstacles: [ObstacleNode]) -> Bool {
        
        guard oldObstacles.count >= 2 else { return true }
        let lastObstacle = oldObstacles.reversed()[0]
        let obstaclePriorToLastObstacle = oldObstacles.reversed()[1]
        
        if lastObstacle.height != .noObstacle && obstaclePriorToLastObstacle.height == .noObstacle {
            
            if obstacle.height == .noObstacle {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}

