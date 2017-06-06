//
//  MainCharacterNodeBehaviourController.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation

class MainCharacterNodeBehaviourController {
    
    let mainCharacter: MainCharacterNode
    
    init(withMainCharacter mainCharacter: MainCharacterNode) {
        self.mainCharacter = mainCharacter
        self.mainCharacter.behaviours = behaviours
    }
}

//MARK: - Possible Behaviours

extension MainCharacterNodeBehaviourController {
    
    var behaviours: [MainCharacterNodeBehaviour] {
        switch mainCharacter.representedCharacter {
        case .basic:
            return basicCharacterBehaviour;
        }
    }
    
    var basicCharacterBehaviour: [MainCharacterNodeBehaviour] {
        let behaviours: [MainCharacterNodeBehaviour] = [
            MainCharacterNodeJumpBehaviour(forMainCharacter: mainCharacter),
            MainCharacterNodeHorizontalLimitBehaviour(forMainCharacter: mainCharacter)
        ]
        
        return behaviours
    }
}
