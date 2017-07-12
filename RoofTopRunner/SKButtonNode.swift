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
    static let labelName = "ButtonLabel"
    //MARK: - Properties
    
    var action: (Void) -> Void
    let imageName: String
    var isDisabledState = false
    var isCurrentlyTouched = false
    
    //MARK: - Initializer
    
    convenience init(withTitle title: String, fontSize: CGFloat, imageName: String, size: CGSize, action: @escaping (Void) -> Void) {
        self.init(withImageName: imageName, size: size, action: action)
        let titleLabel = SKLabelNode(text: title)
        titleLabel.name = SKButtonNode.labelName
        titleLabel.verticalAlignmentMode = .center
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.fontName = "PressStart2P"
        titleLabel.fontSize = fontSize
        titleLabel.zPosition = 1
        titleLabel.position = labelPositionInRegardsToAnchorPoint
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
    override var anchorPoint: CGPoint {
        didSet {
            let label = childNode(withName: SKButtonNode.labelName)
            label?.position = labelPositionInRegardsToAnchorPoint
        }
    }
}

//MARK: - Helpers

extension SKButtonNode {
    
    
    var labelPositionInRegardsToAnchorPoint: CGPoint {
        switch anchorPoint {
        case CGPoint.normalizedUpperLeft:
            return CGPoint(x: size.width / 2, y: -size.height / 2)
        case CGPoint.normalizedLowerLeft:
            return CGPoint(x: size.width / 2, y: size.height / 2)
        case CGPoint.normalizedUpperRight:
            return CGPoint(x: -size.width / 2, y: -size.height / 2)
        case CGPoint.normalizedLowerRight:
            return CGPoint(x: -size.width / 2, y: size.height / 2)
        default:
            return .zero
        }
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

    func buttonTouchesCanceled() {
        if isCurrentlyTouched {
            isCurrentlyTouched = false
            if isDisabledState {
                enterDisabledState()
            } else {
                enterNormalState()
            }
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
