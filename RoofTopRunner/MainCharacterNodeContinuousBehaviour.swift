//
//  MainCharacterNodeContinuousBehaviour.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation

class MainCharacterNodeContinuousBehaviour: MainCharacterNodeBehaviour {
    
    //MARK: - Properties
    
    var duration: TimeInterval = 0.0
    var node: MainCharacterNode?
    
    //MARK: - Initialization
    
    init(forMainCharacter character: MainCharacterNode, duration: TimeInterval) {
        node = character;
        self.duration = duration
    }
    
    
    //MARK: - Behaviour
    
    func perform() {
        if duration != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                self.stopPerforming()
            })
        }
    }
    
    func stopPerforming() {
        guard let physicsBody = node?.physicsBody else { return }
        physicsBody.allowsRotation = true
    }
}
