//
//  GameOverLayerNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/11/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class GameOverLayerNode: SKNode {
    
    static let gameOverLayerName = "GameOverLayerName"
    
    override init() {
        super.init()
        name = GameOverLayerNode.gameOverLayerName

        let gameOverNode = GameOverNode (
            withTopButtonImageName: "", topButtonAction: { (Void) in
                print("top button pressed")
        },
            withBottomButtonImageName: "", bottomButtonAction: { (Void) in
                print("bottom button pressed")
        },
            withLeftTopButtonImageName: "", leftTopButtonAction: { (Void) in
                print("let top button pressed")
        },
            withLeftBottomButtonImageName: "", leftBottomButtonAction: { (Void) in
                print("left bottom button pressed")
        },
            withRightTopButtonImageName: "", rightTopButtonAction: { (Void) in
                print("right top button pressed")
        },
            withRightBottomButtonImageName: "") { (Void) in
                print("right bottom button pressed")
        }
        addChild(gameOverNode)
        gameOverNode.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gameOverNode: GameOverNode? {
        return childNode(withName: GameOverNode.gameOverName) as? GameOverNode
    }
}
