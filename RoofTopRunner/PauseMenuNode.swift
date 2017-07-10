//
//  PauseMenuNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 7/10/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class PauseMenuNode: SKNode {
    
    static let PauseNodeName = "PauseNodeName"
    
    override init() {
        super.init()
        name = PauseMenuNode.PauseNodeName
        placePauseLabel()
        sceneStateDidUpdateTo(.running)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PauseMenuNode {
    fileprivate func placePauseLabel() {
        let distanceLabel = SKLabelNode(text: "PAUSE".localized)
        distanceLabel.fontName = "PressStart2P"
        distanceLabel.fontSize = 50
        addChild(distanceLabel)
    }
}

extension PauseMenuNode: EndlessLevelSceneStateAwareChildNode {
    func sceneStateDidUpdateTo(_ state: EndlessLevelScene.States) {
        switch state {
        case .pause:    alpha = 1.0
        default:        alpha = 0.0
        }
    }
}
