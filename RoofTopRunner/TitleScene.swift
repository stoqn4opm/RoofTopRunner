//
//  TitleScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 8/19/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupTapToStart()
    }
}

extension TitleScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeAllActions()
        SoundManager.shared.playSoundEffectNamed("sfx_go_to_menu")
        run(SKAction.sequence([SKAction.wait(forDuration: 1.8),
                               SKAction.fadeOut(withDuration: 1),
                               SKAction.run { GameManager.shared.loadMenuScene() }]))
        
    }
}

//MARK: - Tap To Play Gradient Scroll

extension TitleScene {
    
    func setupTapToStart() {
        guard let label = childNode(withName: "//tapToPlay") else { return }
        guard let tapToPlayContainer = childNode(withName: "tapToPlayContainer") else { return }
        guard let background1 = childNode(withName: "tapToPlayBckg1") as? SKSpriteNode else { return }
        guard let background2 = childNode(withName: "tapToPlayBckg2") as? SKSpriteNode else { return }
        guard let background3 = childNode(withName: "tapToPlayBckg3") as? SKSpriteNode else { return }
        
        label.removeFromParent()
        background1.removeFromParent()
        background2.removeFromParent()
        background3.removeFromParent()
        
        let cropNode = SKCropNode()
        cropNode.position = label.position
        cropNode.zPosition = label.zPosition
        label.position = .zero
        cropNode.maskNode = label
        
        cropNode.addChild(background1)
        background1.position = .zero
        
        cropNode.addChild(background2)
        background2.position = .zero
        
        cropNode.addChild(background3)
        background3.position = .zero
        
        tapToPlayContainer.addChild(cropNode)
        
        moveBackgroundLayers(layer1: background2, layer2: background3)
    }
    
    func moveBackgroundLayers(layer1: SKSpriteNode, layer2: SKSpriteNode) {
        
        layer1.position = CGPoint(x: 0, y: layer1.size.height / 2)
        layer2.position = CGPoint(x: 0, y: -layer2.size.height / 2)
        
        let repeatedPart2 = SKAction.sequence([SKAction.moveBy(x: 0, y: layer2.size.height * 1.5, duration: 1.5),
                                               SKAction.run { layer2.position = CGPoint(x: 0, y: -layer2.size.height / 2) }])
        
        layer2.run(SKAction.repeatForever(repeatedPart2))
        
        
        
        
        let moveToCorrectPlace = SKAction.sequence([SKAction.moveBy(x: 0, y: layer1.size.height * 0.5, duration: 0.5),
                                                    SKAction.run { layer1.position = CGPoint(x: 0, y: -layer1.size.height / 2) }])
        
        let repeatedPart1 = SKAction.sequence([SKAction.moveBy(x: 0, y: layer1.size.height * 1.5, duration: 1.5),
                                               SKAction.run { layer1.position = CGPoint(x: 0, y: -layer1.size.height / 2) }])
        
        layer1.run(SKAction.sequence([moveToCorrectPlace, SKAction.repeatForever(repeatedPart1)]))
    }
}
