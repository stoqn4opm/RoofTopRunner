//
//  GameOverLayerNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/11/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class GameOverLayerNode: SKNode {
    
    //MARK: - Static Properties
    
    static let gameOverLayerName = "GameOverLayerName"
    
    //MARK: - Initialization
    
    override init() {
        super.init()
        name = GameOverLayerNode.gameOverLayerName

        let gameOverNode = GameOverNode(
            withTopButtonImageName: "gameOverRectBlock", topButtonText: "MAIN MENU".localized, topButtonAction: mainMenuButton,
            withBottomButtonImageName: "gameOverRectBlock", bottomButtonText: "RETRY".localized, bottomButtonAction: retryButtonAction,
            withLeftTopButtonImageName: "gameOverSquareBlock", leftTopButtonText: "f", leftTopButtonAction: facebookButtonAction,
            withLeftBottomButtonImageName: "gameOverSquareBlock", leftBottomButtonText: "t", leftBottomButtonAction: twitterButtonAction,
            withRightTopButtonImageName: "gameOverSquareBlock", rightTopButtonText: "G+", rightTopButtonAction: googlePlusButtonAction,
            withRightBottomButtonImageName: "gameOverSquareBlock", rightBottomButtonText: "+", rightBottomButtonAction: moreButtonAction)
        
        addChild(gameOverNode)
        gameOverNode.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: GameOverNode ref

extension GameOverLayerNode {
    var gameOverNode: GameOverNode? {
        return childNode(withName: GameOverNode.gameOverName) as? GameOverNode
    }
}

//MARK: - Button Actions
//MARK: - 

//MARK: Game Menu Button
extension GameOverLayerNode {
    
    var mainMenuButton: (Void) -> Void  {
        return { GameManager.shared.loadMenuScene() }
    }
}

//MARK: Retry Button
extension GameOverLayerNode {
    
    var retryButtonAction: (Void) -> Void  {
        return {
            GameManager.shared.loadEndlessLevelScene()
        }
    }
}

//MARK: Facebook Button
extension GameOverLayerNode {
    
    var facebookButtonAction: (Void) -> Void  {
        return { print("top button pressed") }
    }
}

//MARK: Twitter Button
extension GameOverLayerNode {
    
    var twitterButtonAction: (Void) -> Void  {
        return { print("top button pressed") }
    }
}

//MARK: Google+ Button
extension GameOverLayerNode {
    
    var googlePlusButtonAction: (Void) -> Void  {
        return { print("top button pressed") }
    }
}

//MARK: More Button
extension GameOverLayerNode {
    
    var moreButtonAction: (Void) -> Void  {
        return { print("top button pressed") }
    }
}
