//
//  IntroStoryScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 8/17/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit
import AVFoundation

class IntroStoryScene: SKScene {

    fileprivate var alreadyTapped: Bool = false
    fileprivate var isAbleToTap: Bool = false
    
    override func didMove(to view: SKView) {
        multilineLabel()
        setupAnimations()
        tapToContinueLabel()

        SoundManager.shared.playBackgroundMusicNamed("bgm_introStoryScene")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {  self.isAbleToTap = true }
    }
}

//MARK: - No Skip Animation

extension IntroStoryScene {
    func setupAnimations() {
        guard let label = camera?.childNode(withName: "label") as? SKMultilineLabel else { return }
        guard let storyImage = childNode(withName: "storyNode") as? SKSpriteNode else { return }
        guard let computerImage = childNode(withName: "computerNode") as? SKSpriteNode else { return }
        
        var sequence: [SKAction] = []
        sequence.append(SKAction.run {  })
        sequence.append(SKAction.wait(forDuration: 7))
        sequence.append(SKAction.run{ label.setTextCharByChar(self.text) })
        sequence.append(SKAction.wait(forDuration: 24))
        sequence.append(contentsOf: reusedPartOfActionSequence)
        sequence.append(SKAction.wait(forDuration: 0.5))
        sequence.append(SKAction.run {
            label.alpha = 1
            label.setTextCharByChar(self.textStory)
            label.alignment = .right
            storyImage.run(SKAction.fadeIn(withDuration: 0.3))})
        sequence.append(SKAction.wait(forDuration: 14)) // wait on second part of story
        sequence.append(SKAction.run { storyImage.run(SKAction.fadeOut(withDuration: 0.3)) })
        sequence.append(contentsOf: reusedPartOfActionSequence)
        sequence.append(SKAction.wait(forDuration: 0.5))
        sequence.append(SKAction.run {
            label.alpha = 1
            label.setTextCharByChar(self.textComputer)
            label.alignment = .left
            computerImage.run(SKAction.fadeIn(withDuration: 0.3))})
        sequence.append(SKAction.wait(forDuration: 12)) // wait on third part of the story
        sequence.append(SKAction.run { computerImage.run(SKAction.fadeOut(withDuration: 0.3)) })
        sequence.append(contentsOf: reusedPartOfActionSequence)
        sequence.append(finalAction(shouldFlash: false))
        sequence.append(SKAction.run {
        })
        run(SKAction.sequence(sequence), withKey: "animation")
    }
    
    
    fileprivate var reusedPartOfActionSequence: [SKAction] {
        let label = camera?.childNode(withName: "label")
        var sequence: [SKAction] = []
        sequence.append(SKAction.run({
            label?.run(SKAction.fadeOut(withDuration: 0.2))
            label?.run(SKAction.moveBy(x: 0, y: 20, duration: 0.2))
            
        }))
        return sequence
    }
}

extension IntroStoryScene {
    
    var text: String { return "LONG TIME AGO IN A GALAXY FAR FAR AWAY \n STOYAN AND ISKREN WERE DEVELOPING \n AN 8 BIT GAME...".localized }
    var textStory: String { return "IT WAS UP TO ISKREN TO COME UP WITH IMMERSIVE STORY".localized }
    var textComputer: String { return "STOYAN'S DUTY WAS TO CODE AND SIMPLY MAKE IT HAPPEN!!!".localized }
    
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
        if isAbleToTap {
            if !alreadyTapped {
                run(finalAction(shouldFlash: true), withKey: "animation")
                alreadyTapped = true
            }
        }
    }
    
    func finalAction(shouldFlash: Bool) -> SKAction {
        let label = camera?.childNode(withName: "label")
        let tapLabel = childNode(withName: "tapLabel")
        let whiteFlash = childNode(withName: "whiteFlash")
        
        label?.removeAllActions()
        removeAllActions()
        
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.1)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.1)
        
        var sequence: [SKAction] = [SKAction.run { SoundManager.shared.stopBackgroundMusic() }]
        
        if shouldFlash {
            SoundManager.shared.playSoundEffectNamed("sfx_endOfIntroScene")
            sequence.append(SKAction.run {
                whiteFlash?.run(SKAction.sequence([fadeInAction, fadeOutAction]))
                tapLabel?.removeAllActions()
                tapLabel?.run(SKAction.fadeOut(withDuration: 0.2))
                label?.alpha = 0
            })
        }
        sequence.append(SKAction.fadeOut(withDuration: 1))
        sequence.append(SKAction.wait(forDuration: 0.4))
        sequence.append(SKAction.run { GameManager.shared.loadTitleScene() })
        
        return SKAction.sequence(sequence)
    }
}

extension IntroStoryScene {
    func tapToContinueLabel() {
        guard let tapLabel = childNode(withName: "tapLabel") as? SKLabelNode else { return }
        guard let backgroundNode = childNode(withName: "labelBackground") else { return }
        backgroundNode.removeFromParent()
        tapLabel.removeFromParent()
        
        tapLabel.fontName = "PressStart2P"
        tapLabel.fontSize = 30
        tapLabel.text = "TAP TO SKIP".localized
        
        let cropContainer = SKNode()
        let cropNode = SKCropNode()
        cropNode.position = tapLabel.position
        tapLabel.position = .zero
        backgroundNode.position = .zero
        cropNode.maskNode = tapLabel
        cropNode.addChild(backgroundNode)
        cropContainer.addChild(cropNode)
        addChild(cropContainer)
        cropContainer.zPosition = 1
        cropContainer.alpha = 0
        cropContainer.run(SKAction.sequence([SKAction.wait(forDuration: 15), SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 1.5), SKAction.fadeOut(withDuration: 1.5)]))]))
    }
}
