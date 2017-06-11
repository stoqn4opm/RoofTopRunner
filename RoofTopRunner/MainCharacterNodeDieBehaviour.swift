//
//  MainCharacterNodeDieBehaviour.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/7/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class MainCharacterNodeDieBehaviour: MainCharacterNodeEventDrivenBehaviour {
    
    //MARK: - Static Properties
    
    static let eventStartName = Notification.Name("DieEventStart")
    static func makeStartEvent() {
        NotificationCenter.default.post(name: MainCharacterNodeDieBehaviour.eventStartName, object: nil)
    }
    
    //MARK: - Properties
    
    fileprivate let wasHavingPhysicsBody: Bool
    
    //MARK: - Lifecycle
    
    init(forMainCharacter character: MainCharacterNode) {
        self.wasHavingPhysicsBody = character.physicsBody != nil
        super.init(withEventStartName: MainCharacterNodeDieBehaviour.eventStartName, eventEndName: nil, mainCharacterNode: character)
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

        guard let node = self.node else { return }
        guard let scene = node.scene as? EndlessLevelScene else { return }
        scene.state = .gameOver
        node.removeAllActions()
        node.removeFromParent()
    }
}
