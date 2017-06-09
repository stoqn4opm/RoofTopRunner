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
    
    static func pauseButton(action: @escaping (Void) -> Void) -> SKButtonNode {
        let pauseButton = SKButtonNode(withImageName: "", action: action)
        pauseButton.name = SKButtonNode.pauseButtonName
        return pauseButton
    }
}

class SKButtonNode: SKSpriteNode {
    
    var action: (Void) -> Void
    
    init(withImageName imageName: String, action: @escaping (Void) -> Void) {
        self.action = action
        super.init(texture: nil, color: .cyan, size: CGSize(width: 50, height: 50))
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
