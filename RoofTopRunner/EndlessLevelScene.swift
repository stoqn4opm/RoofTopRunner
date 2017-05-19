//
//  EndlessLevelScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit
import SwiftyJSON

class EndlessLevelScene: SKScene {
    
    override func sceneDidLoad() {
        self.backgroundColor = .blue
        self.anchorPoint = .normalizedLowerLeft
        
        
        let obstaclePage = ObstaclesLayerNode(withSize: self.size)
        self.addChild(obstaclePage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            obstaclePage.rate = 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                obstaclePage.rate = 10
            }
        }
    }
}
