//
//  MainCharacterNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/31/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import SpriteKit

enum MainCharacters {
    case basic
}

//MARK: - Public Interfaces

extension MainCharacterNode {
    
    static var basic: MainCharacterNode {
        return MainCharacterNode(withCharacter: .basic)
    }
}

class MainCharacterNode: SKSpriteNode {
    
    //MARK: - Static Properties
    
    static let characterSize = CGSize(width: 50, height: 140)
    static let characterName = "CharacterNode"
    
    //MARK: - Properties
    
    let representedCharacter: MainCharacters
    var behaviours: [MainCharacterNodeBehaviour] = []
    var behaviourController: MainCharacterNodeBehaviourController!
    var isInAir = false // behaviour thats makes the character leave the ground should update this appropriately
    
    
    //MARK: - Constructors
    
    fileprivate init(withCharacter representingCharacterType: MainCharacters) {
        self.representedCharacter = representingCharacterType
        super.init(texture: nil, color: .gray, size: MainCharacterNode.characterSize)
        self.behaviourController = MainCharacterNodeBehaviourController(withMainCharacter: self)
        self.name = MainCharacterNode.characterName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Physics Collisions

extension MainCharacterNode {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == MainCharacterNode.characterName && contact.bodyB.node?.name == ObstacleNode.obstacleName) ||
            (contact.bodyB.node?.name == MainCharacterNode.characterName && contact.bodyA.node?.name == ObstacleNode.obstacleName) {
            
            isInAir = false
        }
        else if (contact.bodyA.node?.name == MainCharacterNode.characterName && contact.bodyB.node?.name == ObstacleNode.holeName) ||
            (contact.bodyB.node?.name == MainCharacterNode.characterName && contact.bodyA.node?.name == ObstacleNode.holeName)  {
            
            MainCharacterNodeDieBehaviour.makeStartEvent()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.node?.name == MainCharacterNode.characterName && contact.bodyB.node?.name == ObstacleNode.obstacleName) ||
            (contact.bodyB.node?.name == MainCharacterNode.characterName && contact.bodyA.node?.name == ObstacleNode.obstacleName) {
            
        }
    }
}
