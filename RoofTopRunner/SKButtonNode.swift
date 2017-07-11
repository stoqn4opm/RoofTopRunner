//
//  SKButtonNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/9/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class SKButtonNode: SKSpriteNode {
    
    //MARK: - Static Properties
    
    static let hudButtonSize = CGSize(width: 100, height: 100)
    
    //MARK: - Properties
    
    var action: (Void) -> Void
    let imageName: String
    var isDisabledState = false
    var isCurrentlyTouched = false
    
    //MARK: - Initializer
    
    convenience init(withTitle title: String, fontSize: CGFloat, imageName: String, size: CGSize, action: @escaping (Void) -> Void) {
        self.init(withImageName: imageName, size: size, action: action)
        let titleLabel = SKLabelNode(text: title)
        titleLabel.fontName = "PressStart2P"
        titleLabel.fontSize = fontSize
        titleLabel.zPosition = 1
        titleLabel.isUserInteractionEnabled = false
        addChild(titleLabel)
    }
    
    init(withImageName imageName: String, size: CGSize, action: @escaping (Void) -> Void) {
        self.action = action
        self.imageName = imageName
        super.init(texture: nil, color: .cyan, size: size)
        self.anchorPoint = .normalizedLowerLeft
        enterNormalState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Action Firing

extension SKButtonNode {
    
    func fireAction() {
        action()
    }
}


//MARK: - States

extension SKButtonNode {
    func enterNormalState() {
        self.texture = SKTexture(imageNamed: "\(imageName).png")
        isDisabledState = false
    }
    
    func enterTransionToDisabledState() {
        self.texture = SKTexture(imageNamed: "\(imageName)Pressed.png")
    }
    
    func enterDisabledState() {
        self.texture = SKTexture(imageNamed: "\(imageName)Disabled.png")
        isDisabledState = true
    }
    
    func enterTransitionToNormalState() {
        self.texture = SKTexture(imageNamed: "\(imageName)DisabledPressed.png")
    }
}


extension SKButtonNode {

    func buttonTouched() {
        isCurrentlyTouched = true
        if !isDisabledState {
            enterTransionToDisabledState()
        } else {
            enterTransitionToNormalState()
        }
    }

    func buttonTouchedEnded() {
        
        if isCurrentlyTouched {
            isCurrentlyTouched = false
            if !isDisabledState {
                enterDisabledState()
            } else {
                enterNormalState()
            }
            action()
        }
    }
}
