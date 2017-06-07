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
            MainCharacterNodeNoRotationBehaviour(forMainCharacter: mainCharacter),
            MainCharacterNodeDownwardJumpBehaviour(forMainCharacter: mainCharacter),
            MainCharacterNodeDieBehaviour(forMainCharacter: mainCharacter)
        ]
        
        return behaviours
    }
}

//MARK: - Update Behaviours

extension MainCharacterNodeBehaviourController {
    func update(_ currentTime: TimeInterval) {
        for behaviour in mainCharacter.behaviours {
            behaviour.update?(currentTime)
        }
    }
}
