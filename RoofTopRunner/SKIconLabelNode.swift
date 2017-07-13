//
//  SKIconLabelNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/9/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

extension SKLabelNode {

    fileprivate static let iconSizeScaleFactor = CGFloat(2.2)
    fileprivate static let iconDistanceFactor = CGFloat(2.5)
    
    static func iconLabelNode(withText text: String, iconNamed: String) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontName = "PressStart2P"
        label.fontSize = 35
        label.prepareIcon(named: iconNamed)

        return label
    }
    
    private func prepareIcon(named iconName: String) {
        let coinTexture = SKTexture(imageNamed: iconName)
        let icon = SKSpriteNode(texture: coinTexture, color: .purple,
                                size: CGSize(width: frame.height * SKLabelNode.iconSizeScaleFactor,
                                             height: frame.height * SKLabelNode.iconSizeScaleFactor))
        
        icon.position = CGPoint(x: -frame.height * SKLabelNode.iconDistanceFactor - frame.width / 2, y: frame.height / 2.0 + icon.size.height * 0.5 * 0.1)
        icon.anchorPoint = .normalizedLeft
        addChild(icon)
    }
}
