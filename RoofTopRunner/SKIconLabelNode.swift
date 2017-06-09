//
//  SKIconLabelNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/9/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

extension SKLabelNode {

    fileprivate static let iconSizeScaleFactor = CGFloat(1.2)
    fileprivate static let iconDistanceFactor = CGFloat(1.5)
    
    static func iconLabelNode(withText text: String, iconNamed: String) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontSize = 50
        label.prepareIcon()
        return label
    }
    
    private func prepareIcon() {

        let icon = SKSpriteNode(color: .purple, size: CGSize(width: frame.height * SKLabelNode.iconSizeScaleFactor,
                                                             height: frame.height * SKLabelNode.iconSizeScaleFactor))
        
        icon.position = CGPoint(x: -frame.height * SKLabelNode.iconDistanceFactor - frame.width / 2, y: frame.height / 2.0)
        icon.anchorPoint = .normalizedLeft
        addChild(icon)
    }
}
