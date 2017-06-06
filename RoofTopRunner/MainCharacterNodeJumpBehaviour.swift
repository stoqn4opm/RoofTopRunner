//
//  MainCharacterNodeJumpBehaviour.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class MainCharacterNodeJumpBehaviour: MainCharacterNodeEventDrivenBehaviour {
    
    //MARK: - Static Properties
    
    static let eventName = Notification.Name("JumpEvent")
    static func makeEvent() {
        NotificationCenter.default.post(name: MainCharacterNodeJumpBehaviour.eventName, object: nil)
    }
    
    //MARK: - Properties
    
    fileprivate let wasHavingPhysicsBody: Bool
    
    //MARK: - Lifecycle
    
    init(forMainCharacter character: MainCharacterNode) {
        self.wasHavingPhysicsBody = character.physicsBody != nil
        super.init(withEventName: MainCharacterNodeJumpBehaviour.eventName, mainCharacterNode: character)
        createPhysicsBodyIfNeeded()
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
        physicsBody.applyImpulse(CGVector(dx: 0, dy: 280))
    }
}
