//
//  ObstacleNodeAppenderController.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/23/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import UIKit

class ObstacleNodeAppenderController {

    //MARK: - Properties
    
    let obstacleAppender: ObstacleNodeAppender
    
    //MARK: - Initializer
    
    init(with obstacleAppender: ObstacleNodeAppender) {
        self.obstacleAppender = obstacleAppender
        self.obstacleAppender.appendRules = appendRules
    }
}

//MARK: - Append Rules

extension ObstacleNodeAppenderController {
    
    var appendRules: [ObstacleNodeAppendRule] {
        var rules: [ObstacleNodeAppendRule] = []
        
        rules.append(HoleOrSameAsPreviousRule())
        rules.append(SameAsPriorToTwoHolesRule())
        rules.append(NoBiggerHeightDifferenceThanOneAfterHoleRule())
        rules.append(NoLessThanTwoConsecutiveObstacles())
        
        return rules
    }
}

//MARK: - Speed Rate

fileprivate let initialWaitDuration: TimeInterval = 3
fileprivate let firstLevelOfAccelerationDuration: TimeInterval = 3
fileprivate let desiredAccelerationOnFirstLevel: Double = 5
fileprivate let finalLevelOfAccelerationDuration: Double = 1200 // 20 mins in seconds

extension ObstacleNodeAppenderController {
    
    func speedRate(forPassedTime time: TimeInterval) -> CGFloat {
        if time <= initialWaitDuration {
            return 0
        } else if initialWaitDuration < time && time <= initialWaitDuration + firstLevelOfAccelerationDuration {
            
            let slope = (desiredAccelerationOnFirstLevel - 0) / (firstLevelOfAccelerationDuration - 0)
            let result = slope * (time - initialWaitDuration - 0) + 0
            return CGFloat(result)
            
        } else {
            let slope = (Double(ObstaclesLayerNode.speedRateLimiter) - desiredAccelerationOnFirstLevel) / ((finalLevelOfAccelerationDuration - (initialWaitDuration + firstLevelOfAccelerationDuration)) - (firstLevelOfAccelerationDuration - (initialWaitDuration + firstLevelOfAccelerationDuration)))
            let result = slope * (time - initialWaitDuration - (initialWaitDuration + firstLevelOfAccelerationDuration)) + desiredAccelerationOnFirstLevel
            return CGFloat(result)
        }
    }
}

