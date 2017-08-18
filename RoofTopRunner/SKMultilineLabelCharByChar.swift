//
//  SKMultilineLabelCharByChar.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 8/18/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

extension SKMultilineLabel {
    
    func setTextCharByChar(_ text: String) {
        
        let chars = text.characters
        var actions: [SKAction] = []
        var stringsForApplying: [String] = []
        
        var stringForApplying = ""
        for char in chars {
            stringForApplying =  "\(stringForApplying)\(char)"
            stringsForApplying.append(stringForApplying)
        }
        
        for string in stringsForApplying {
            let action = SKAction.run { self.text = string }
            if string.characters.last == "\n" {
                actions.append(action)
                actions.append(SKAction.wait(forDuration: 2))
            } else {
                let sound = SKAction.playSoundFileNamed("sfx_letterType", waitForCompletion: false)
                actions.append(SKAction.group([action, sound]))
            }
            actions.append(SKAction.wait(forDuration: 0.18))
        }
        run(SKAction.sequence(actions))
    }
}
