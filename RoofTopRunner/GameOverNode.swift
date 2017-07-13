//
//  GameOverNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/11/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class GameOverNode: SKSpriteNode {
    
    //MARK: Static Properties
    
    static let gameOverName = "GameOverNodeName"
    static let gameOverSize = CGSize(width: 700, height: 550)
    fileprivate static let arrangeFactor: CGFloat = 0.5
    fileprivate let fontSize: CGFloat = 50
    
    //MARK: - Initialization
    
    init(withTopButtonImageName tbImageName: String?,
         topButtonText: String,
         topButtonAction tbAction: ((Void) -> Void)?,
        
         withBottomButtonImageName bbImageName: String?,
         bottomButtonText: String,
         bottomButtonAction bbAction: ((Void) -> Void)?,
         
         withLeftTopButtonImageName ltbImageName: String?,
         leftTopButtonText: String,
         leftTopButtonAction ltAction: ((Void) -> Void)?,
         
         withLeftBottomButtonImageName lbbImageName: String?,
         leftBottomButtonText: String,
         leftBottomButtonAction lbAction: ((Void) -> Void)?,
         
         withRightTopButtonImageName rtbImageName: String?,
         rightTopButtonText: String,
         rightTopButtonAction rtAction: ((Void) -> Void)?,
         
         withRightBottomButtonImageName rbbImageName: String?,
         rightBottomButtonText: String,
         rightBottomButtonAction rbAction: ((Void) -> Void)?) {
        
        super.init(texture: nil, color: .clear, size: GameOverNode.gameOverSize)
        name = GameOverNode.gameOverName
        prepareGameOverTitle()
        
        if let tbImageName = tbImageName, let tbAction = tbAction {
            prepareTopButton(withImageName: tbImageName, title:topButtonText, action: tbAction)
        }
        if let bbImageName = bbImageName, let bbAction = bbAction {
            prepareBottomButton(withImageName: bbImageName, title:bottomButtonText, action: bbAction)
        }
        if let ltbImageName = ltbImageName, let ltAction = ltAction {
            prepareLeftTopButton(withImageName: ltbImageName, title:leftTopButtonText, action: ltAction)
        }
        if let lbbImageName = lbbImageName, let lbAction = lbAction {
            prepareLeftBottomButton(withImageName: lbbImageName, title: leftBottomButtonText, action: lbAction)
        }
        if let rtbImageName = rtbImageName, let rtAction = rtAction {
            prepareRightTopButton(withImageName: rtbImageName, title: rightTopButtonText, action: rtAction)
        }
        if let rbbImageName = rbbImageName, let rbAction = rbAction {
            prepareRightBottomButton(withImageName: rbbImageName, title: rightBottomButtonText, action: rbAction)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Preparation

extension GameOverNode {
    func prepareGameOverTitle() {
        let titleNode = SKSpriteNode(color: .clear, size: size.scaled(at: GameOverNode.arrangeFactor))
        addChild(titleNode)
    }
    
    func prepareBottomButton(withImageName name: String, title: String, action: @escaping (Void) -> Void) {
        let buttonSize = CGSize(width: size.width, height: size.height * ((1 - GameOverNode.arrangeFactor) / 2 ))
        let bottomButton = SKButtonNode(withTitle: title, fontSize: fontSize, imageName: name, size: buttonSize, action: action)
        bottomButton.position = CGPoint(x: -size.width / 2, y: -size.height / 2)
        bottomButton.anchorPoint = .normalizedLowerLeft
        addChild(bottomButton)
    }
    
    func prepareTopButton(withImageName name: String, title: String, action: @escaping (Void) -> Void) {
        let buttonSize = CGSize(width: size.width, height: size.height * ((1 - GameOverNode.arrangeFactor) / 2 ))
        let topButton = SKButtonNode(withTitle: title, fontSize: fontSize, imageName: name, size: buttonSize, action: action)
        topButton.position = CGPoint(x: -size.width / 2, y: size.height / 2)
        topButton.anchorPoint = .normalizedUpperLeft
        addChild(topButton)
    }
    
    func prepareLeftTopButton(withImageName name: String, title: String, action: @escaping (Void) -> Void) {
        let buttonSize = CGSize(width: size.width * ((1 - GameOverNode.arrangeFactor) / 2 ),
                                height: size.height * (GameOverNode.arrangeFactor / 2))
        let leftTopButton = SKButtonNode(withTitle: title, fontSize: fontSize, imageName: name, size: buttonSize, action: action)
        leftTopButton.position = CGPoint(x: -size.width / 2, y: leftTopButton.size.height)
        leftTopButton.anchorPoint = .normalizedUpperLeft
        addChild(leftTopButton)
    }
    
    func prepareLeftBottomButton(withImageName name: String, title: String, action: @escaping (Void) -> Void) {
        let buttonSize = CGSize(width: size.width * ((1 - GameOverNode.arrangeFactor) / 2 ),
                                height: size.height * (GameOverNode.arrangeFactor / 2))
        let leftBottomButton = SKButtonNode(withTitle: title, fontSize: fontSize, imageName: name, size: buttonSize, action: action)
        leftBottomButton.position = CGPoint(x: -size.width / 2, y: -leftBottomButton.size.height)
        leftBottomButton.anchorPoint = .normalizedLowerLeft
        addChild(leftBottomButton)
    }
    
    func prepareRightTopButton(withImageName name: String, title: String, action: @escaping (Void) -> Void) {
        let buttonSize = CGSize(width: size.width * ((1 - GameOverNode.arrangeFactor) / 2 ),
                                height: size.height * (GameOverNode.arrangeFactor / 2))
        let rightTopButton = SKButtonNode(withTitle: title, fontSize: fontSize, imageName: name, size: buttonSize, action: action)
        rightTopButton.position = CGPoint(x: size.width / 2, y: rightTopButton.size.height)
        rightTopButton.anchorPoint = .normalizedUpperRight
        addChild(rightTopButton)
    }
    
    func prepareRightBottomButton(withImageName name: String, title: String, action: @escaping (Void) -> Void) {
        let buttonSize = CGSize(width: size.width * ((1 - GameOverNode.arrangeFactor) / 2 ),
                                height: size.height * (GameOverNode.arrangeFactor / 2))
        let rightBottomButton = SKButtonNode(withTitle: title, fontSize: fontSize, imageName: name, size: buttonSize, action: action)
        rightBottomButton.position = CGPoint(x: size.width / 2, y: -rightBottomButton.size.height)
        rightBottomButton.anchorPoint = .normalizedLowerRight
        addChild(rightBottomButton)
    }
}

//MARK: - Touch Handling

extension GameOverNode {
    func gameOverTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) -> Bool {
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return false }
        guard let touchedNode = self.nodes(at: location).first as? SKButtonNode else { return false }
        touchedNode.fireAction()
        return true
    }
}
