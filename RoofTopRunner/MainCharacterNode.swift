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
