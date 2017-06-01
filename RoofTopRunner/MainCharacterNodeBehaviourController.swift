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
    
    var behaviours: [MainCharacterNodeBehaviour] {
        let behaviours = [MainCharacterNodeJumpBehaviour(forMainCharacter: mainCharacter)]
        return behaviours
    }
}
