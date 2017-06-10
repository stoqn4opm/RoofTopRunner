//
//  SKButtonNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/9/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

extension SKButtonNode {
    
    static let pauseButtonName = "PauseButtonName"
    static let musicControlButtonName = "MusicControlButtonName"
    static let sfxControlButtonName = "SFXControlButtonName"
    
    static let hudButtonSize = CGSize(width: 100, height: 100)
    
    static func pauseButton(action: @escaping (Void) -> Void) -> SKButtonNode {
        let pauseButton = SKButtonNode(withImageName: "", size: SKButtonNode.hudButtonSize, action: action)
        pauseButton.name = SKButtonNode.pauseButtonName
        return pauseButton
    }
    
    static func musicControlButton(action: @escaping (Void) -> Void) -> SKButtonNode {
        let musicControlButton = SKButtonNode(withImageName: "", size: SKButtonNode.hudButtonSize, action: action)
        musicControlButton.name = SKButtonNode.musicControlButtonName
        return musicControlButton
    }
    
    static func sfxControlButton(action: @escaping (Void) -> Void) -> SKButtonNode {
        let sfxControlButton = SKButtonNode(withImageName: "", size: SKButtonNode.hudButtonSize, action: action)
        sfxControlButton.name = SKButtonNode.sfxControlButtonName
        return sfxControlButton
    }
}

class SKButtonNode: SKSpriteNode {
    
    var action: (Void) -> Void
    
    init(withImageName imageName: String, size: CGSize, action: @escaping (Void) -> Void) {
        self.action = action
        super.init(texture: nil, color: .cyan, size: size)
        self.anchorPoint = .normalizedLowerLeft
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKButtonNode {
    
    func fireAction() {
        action()
    }
}
