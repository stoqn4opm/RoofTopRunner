//
//  EndlessLevelScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit
import SwiftyJSON

protocol EndlessLevelSceneStateAwareChildNode {
    func sceneStateDidUpdateTo(_ state: EndlessLevelScene.States)
}

class EndlessLevelScene: SKScene {
 
    //MARK: - Scores
    
    class Scores {
        var runningDistance: Int64 = 0
        var energyLevel: Double = 1.0
        var coins: Int64 = 0
        var achievementsCount: Int64 = 0
    }
    
    var scores = Scores()
    
    //MARK: - States
    
    enum States {
        case running
        case pause
        case gameOver
    }
    
    private var _state: States = .running
    var state: States {
        get { return _state }
        set {
            switch _state {
            case .running:
                _state = newValue
                notifyStateAwareChildrenAboutStateChange()
            case .gameOver:
                break
            case .pause:
                _state = newValue == .running ? newValue : .pause
                notifyStateAwareChildrenAboutStateChange()
            }
        }
    }
    
    func notifyStateAwareChildrenAboutStateChange() {
        for child in children {
            let stateAwareChild = child as? EndlessLevelSceneStateAwareChildNode
            stateAwareChild?.sceneStateDidUpdateTo(state)
        }
    }
    
    //MARK: Scene Loading
    
    override func sceneDidLoad() {
        self.anchorPoint = .normalizedLowerLeft
        self.physicsWorld.contactDelegate = self
        
        loadObstacleLayer()
        loadMainCharacter()
        loadHUD()
        loadBackgroundLayer()
        loadPauseMenu()
    }
    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
    }
}

//MARK: - Main Character

extension EndlessLevelScene {
    func loadMainCharacter() {
        let mainChar = MainCharacterNode.basic
        self.addChild(mainChar)
        mainChar.position = CGPoint(x: 300, y: 300)
    }
}

//MARK: - Obstacles Layer

extension EndlessLevelScene {
    func loadObstacleLayer() {

        let obstacleLayer = ObstaclesLayerNode(withSize: self.size)
        self.addChild(obstacleLayer)
    }
}

//MARK: - HUD Layer

extension EndlessLevelScene {
    func loadHUD() {
        let hud = HudLayerNode()
        addChild(hud)
    }
}

//MARK: - Background Layer

extension EndlessLevelScene {
    func loadBackgroundLayer() {
        let background = ParallaxBackgroundNode()
        addChild(background)
    }
}

//MARK: - Pause Menu

extension EndlessLevelScene {
    func loadPauseMenu() {
        let pauseMenu = PauseMenuNode()
        pauseMenu.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(pauseMenu)
    }
}

//MARK: - Game Over

extension EndlessLevelScene {
    func loadGameOverLayer() {
//        let gameOverLayer = GameOverLayerNode()
//        gameOverLayer.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        gameOverLayer.zPosition = 1
//        addChild(gameOverLayer)
        
        guard let gameOverContainer = SKNode(fileNamed: "GameOverNodeContainer") else { return }
        gameOverContainer.physicsBody = nil
        gameOverContainer.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        addChild(gameOverContainer)
    }
}

//MARK: - Touch Handling

extension EndlessLevelScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let hud = childNode(withName: HudLayerNode.hudName) as? HudLayerNode {
            if hud.hudTouchesBegan(touches, with: event) { return }
        }
        
        if let gameOverLayer = childNode(withName: GameOverLayerNode.gameOverLayerName) as? GameOverLayerNode {
            if let node = gameOverLayer.gameOverNode {
                if node.gameOverTouchesBegan(touches, with: event) { return }
            }
        }
        
        if touches.count == 3 {
            let obstacleLayer = childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
            obstacleLayer?.showCurrentRateOnScreen(true)
            return
        }
        
        if touches.count == 1 {
            MainCharacterNodeJumpBehaviour.makeStartEvent()
            MainCharacterNodeDownwardJumpBehaviour.makeStartEvent()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        MainCharacterNodeJumpBehaviour.makeEndEvent()
        
        if let hud = childNode(withName: HudLayerNode.hudName) as? HudLayerNode {
            hud.hudTouchesEnded(touches, with: event)
        }
    }
}

//MARK: - Main Loop

extension EndlessLevelScene {
    override func update(_ currentTime: TimeInterval) {
        
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.update(currentTime)
        
        if let mainCharacter = self.childNode(withName: MainCharacterNode.characterName) as? MainCharacterNode {
            mainCharacter.behaviourController.update(currentTime)
        } else {
            if childNode(withName: GameOverLayerNode.gameOverLayerName) == nil {
                loadGameOverLayer()
            }
        }
        
        let parallaxBg = self.childNode(withName: ParallaxBackgroundNode.parallaxBackgroundName) as? ParallaxBackgroundNode
        parallaxBg?.update(currentTime)
    }
}

//MARK: - Physics CallBacks

extension EndlessLevelScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.didBegin(contact)
        
        let mainCharacter = self.childNode(withName: MainCharacterNode.characterName) as? MainCharacterNode
        mainCharacter?.didBegin(contact)
        
        let background = self.childNode(withName: ParallaxBackgroundNode.parallaxBackgroundName) as? ParallaxBackgroundNode
        background?.didBegin(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let obstacleLayer = self.childNode(withName: ObstaclesLayerNode.obstacleLayerName) as? ObstaclesLayerNode
        obstacleLayer?.didEnd(contact)
        
        let mainCharacter = self.childNode(withName: MainCharacterNode.characterName) as? MainCharacterNode
        mainCharacter?.didEnd(contact)
        
        let background = self.childNode(withName: ParallaxBackgroundNode.parallaxBackgroundName) as? ParallaxBackgroundNode
        background?.didEnd(contact)
    }
}
