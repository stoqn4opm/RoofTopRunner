//
//  ObstacleNodeAppender.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/20/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation

class ObstacleNodeAppender {
    
    //MARK: - Global Settings
    
    static let historyObstaclesCount = 10
    
    //MARK: - Properties
    
    fileprivate var obstaclesHistory: [ObstacleNode] = []
    
    //MARK: Public Interface
    
    var appendRules: [ObstacleNodeAppendRule] = []
    
    var next: ObstacleNode {
        
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
                applyTextures()
                return obstacle
            }
            
        } while shouldAppend == false
        return ObstacleNode(withHeight: .noObstacle, textureName: nil)
    }
    
    private func playPattern() {} // will add the possibility to append specific pattern of obstacles in future
    
    var hole: ObstacleNode {
        let hole = ObstacleNode(withHeight: .noObstacle, textureName: nil)
        remember(hole)
        return hole
    }
}

//MARK: - Random Obstacle Generation

extension ObstacleNodeAppender {
    
    fileprivate var randomObstacle: ObstacleNode {
        let randomRawHeight = arc4random_uniform(UInt32(ObstacleHeight.count))
        let height = ObstacleHeight(rawValue: Int(randomRawHeight))
        let obstacle = ObstacleNode(withHeight: height!, textureName: nil)
        return obstacle
    }
}

//MARK: - History Managment

extension ObstacleNodeAppender {
    
    fileprivate func remember(_ obstacle: ObstacleNode) {
        obstaclesHistory.append(obstacle)
        if obstaclesHistory.count >= ObstacleNodeAppender.historyObstaclesCount {
            obstaclesHistory.removeFirst()
        }
    }
}

//MARK: - Textures

extension ObstacleNodeAppender {
    
    fileprivate func applyTextures() {
        
        guard let last = obstaclesHistory.last else { return }
        last.applyTextures(texturesArrayForHeight(last.height))
    }
    
    fileprivate func texturesArrayForHeight(_ height: ObstacleHeight) -> [String] {
        
        switch height {
        case .noObstacle:
            return []
        case .one:
            return [randTopBlockTextureName]
        case .two:
            return [randMidBlockTextureName, randTopBlockTextureName]
        case .three:
            return [randMidBlockTextureName, randMidBlockTextureName, randTopBlockTextureName]
        }
    }
    
    var randMidBlockTextureName: String {
        let idx = arc4random_uniform(UInt32(4)) + 1
        return "Basic\(idx).png"
    }
    
    var randTopBlockTextureName: String {
        let idx = arc4random_uniform(UInt32(10)) + 1
        return "Top\(idx).png"
    }
    
}
