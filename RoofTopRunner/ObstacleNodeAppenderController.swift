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
        
        return rules
    }
}

//MARK: - Speed Rate

extension ObstacleNodeAppenderController {
    
    func speedRate(forPassedTime time: TimeInterval) -> CGFloat {
        return CGFloat((time * time) / 100)
    }
}

