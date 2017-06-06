//
//  MainCharacterNodeNoRotationBehaviour.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/6/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class MainCharacterNodeNoRotationBehaviour: MainCharacterNodeContinuousBehaviour {
    
    //MARK: - Properties
    
    fileprivate let wasHavingPhysicsBody: Bool
    
    //MARK: - Lifecycle
    
    init(forMainCharacter character: MainCharacterNode) {
        self.wasHavingPhysicsBody = character.physicsBody != nil
        super.init(forMainCharacter: character, duration: 0)
        createPhysicsBodyIfNeeded()
        perform()
    }
    
    deinit {
        if !wasHavingPhysicsBody {
            node?.physicsBody = nil
        }
    }
    
    private func createPhysicsBodyIfNeeded() {
        if !wasHavingPhysicsBody {
            guard let character = node else { return }
            character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        }
    }
    
    //MARK: - Behaviour
    
    override func perform() {
        guard let physicsBody = node?.physicsBody else { return }
        physicsBody.allowsRotation = false
        super.perform()
    }
}

