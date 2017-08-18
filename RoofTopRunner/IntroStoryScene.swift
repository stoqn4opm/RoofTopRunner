//
//  IntroStoryScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 8/17/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class IntroStoryScene: SKScene {
    
    override func didMove(to view: SKView) {
        multilineLabel()
        setupAnimations()
        tapToContinueLabel()
    }
}

//MARK: - No Skip Animation

extension IntroStoryScene {
    func setupAnimations() {
        guard let label = camera?.childNode(withName: "label") as? SKMultilineLabel else { return }
        
        var sequence: [SKAction] = []
        sequence.append(SKAction.run{ label.setTextCharByChar(self.text) })
        sequence.append(SKAction.wait(forDuration: 17))
        sequence.append(contentsOf: reusedPartOfActionSequence)
        run(SKAction.sequence(sequence), withKey: "animation")
    }
}

extension IntroStoryScene {
    
    var text: String { return "LONG TIME AGO IN A GALAXY FAR FAR AWAY \n STOYAN AND ISKREN WERE DEVELOPING \n AN 8 BIT GAME...".localized }
    
    func multilineLabel() {
        
        let label = SKMultilineLabel(text: text, labelWidth: 950, pos: .zero, fontName: "PressStart2P", fontSize: 50, fontColor: .white, leading: 60, alignment: .center, shouldShowBorder: false)
        camera?.addChild(label)
        label.pos = CGPoint(x:0, y:label.labelHeight / 2)
        label.zPosition = 1
        label.text = ""
        label.name = "label"
    }
}

//MARK: - Tap to Skip Handling

extension IntroStoryScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let label = camera?.childNode(withName: "label")
        let whiteFlash = childNode(withName: "whiteFlash")
        
        label?.removeAllActions()
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.1)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.1)
        
        var sequence = reusedPartOfActionSequence
        sequence.append(SKAction.group([SKAction.playSoundFileNamed("sfx_endOfIntroScene", waitForCompletion: false), SKAction.run({
            whiteFlash?.run(SKAction.sequence([fadeInAction, fadeOutAction]))
        })]))
        run(SKAction.sequence(sequence), withKey: "animation")
    }
    
    fileprivate var reusedPartOfActionSequence: [SKAction] {
        let label = camera?.childNode(withName: "label")
        let tapLabel = childNode(withName: "tapLabel")
        var sequence: [SKAction] = []
        sequence.append(SKAction.run({
            label?.run(SKAction.fadeOut(withDuration: 0.2))
            label?.run(SKAction.moveBy(x: 0, y: 20, duration: 0.2))
            tapLabel?.removeAllActions()
            tapLabel?.run(SKAction.fadeOut(withDuration: 0.2))
        }))
        return sequence
    }
}

extension IntroStoryScene {
    func tapToContinueLabel() {
        let tapLabel = childNode(withName: "tapLabel") as? SKLabelNode
        
        tapLabel?.fontName = "PressStart2P"
        tapLabel?.fontSize = 30
        tapLabel?.text = "TAP TO SKIP".localized
        tapLabel?.alpha = 0
    }
}
