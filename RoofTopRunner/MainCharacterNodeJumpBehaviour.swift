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
    
    static let eventStartName = Notification.Name("JumpEventStart")
    static let eventEndName = Notification.Name("JumpEventEnd")
    static func makeStartEvent() {
        NotificationCenter.default.post(name: MainCharacterNodeJumpBehaviour.eventStartName, object: nil)
    }
    static func makeEndEvent() {
        NotificationCenter.default.post(name: MainCharacterNodeJumpBehaviour.eventEndName, object: nil)
    }
    
    static let jumpDuration: TimeInterval = 0.1
    
    //MARK: - Properties
    
    fileprivate let wasHavingPhysicsBody: Bool
    fileprivate var isPerforming: Bool = false
    
    fileprivate var startOfPerforming: TimeInterval?
    
    //MARK: - Lifecycle
    
    init(forMainCharacter character: MainCharacterNode) {
        self.wasHavingPhysicsBody = character.physicsBody != nil
        super.init(withEventStartName: MainCharacterNodeJumpBehaviour.eventStartName, eventEndName: MainCharacterNodeJumpBehaviour.eventEndName, mainCharacterNode: character)
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
            character.physicsBody?.restitution = 0.0
        }
    }
    
    //MARK: - Behaviour
    
    override func perform() {
        isPerforming = true
    }
    
    override func stopPerforming() {
        isPerforming = false
        startOfPerforming = nil
    }
    
    //MARK: - Update
    
    func update(_ currentTime: TimeInterval) {
        if isPerforming {
            
            if startOfPerforming == nil {
                
                guard node?.isInAir != true else {
                    isPerforming = false
                    return
                }
                
                startOfPerforming = currentTime
            }
            
            guard let physicsBody = node?.physicsBody else { return }
            let timeSinceStartOfPerforming = currentTime - startOfPerforming!
            
            if timeSinceStartOfPerforming < MainCharacterNodeJumpBehaviour.jumpDuration {
                physicsBody.applyForce(CGVector(dx: 0, dy: 2200 - timeSinceStartOfPerforming))
                node?.isInAir = true
            } else {
                stopPerforming()
            }
        }
    }
}

