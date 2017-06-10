//
//  HudLayerNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/8/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class HudLayerNode: SKNode {
    
    //MARK: - Static Properties
    static let hudName = "HudLayerNodeName"
    
    static let runningDistanceLabelName = "RunningDistanceLabelName"
    static let runningDistanceUpdateNotification = Notification.Name("RunningDistanceUpdateNotification")
    static func updateRunningDistanceEvent() {
        NotificationCenter.default.post(name: runningDistanceUpdateNotification, object: nil)
    }
    
    static let achievementsLabelName = "AchievementsLabelName"
    static let achievementsUpdateNotification = Notification.Name("AchievementsNotification")
    static func updateAchievementsEvent() {
        NotificationCenter.default.post(name: achievementsUpdateNotification, object: nil)
    }
    
    static let energyBarName = "energyBarName"
    static let energyBarUpdateNotification = Notification.Name("EnergyBarNotification")
    static func updateEnergyBarEvent() {
        NotificationCenter.default.post(name: energyBarUpdateNotification, object: nil)
    }
    
    static let coinsLabelName = "coinsLabelName"
    static let coinsLabelUpdateNotification = Notification.Name("CoinsLabelNotification")
    static func updateCoinsLabelEvent() {
        NotificationCenter.default.post(name: coinsLabelUpdateNotification, object: nil)
    }
    
    //MARK: - Initializers
    
    override init() {
        super.init()
        name = HudLayerNode.hudName
        prepareRunningDistanceLabel()
        prepareAchievementsMultiplierLabel()
        prepareEnergyBar()
        prepareCoinsLabel()
        preparePauseButton()
        prepareMusicControlButton()
        prepareSFXControlButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: HudLayerNode.runningDistanceUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: HudLayerNode.achievementsUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: HudLayerNode.energyBarUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: HudLayerNode.coinsLabelUpdateNotification, object: nil)
    }
}

//MARK: - HUD Preparation

extension HudLayerNode {
    
    fileprivate func prepareRunningDistanceLabel() {
        let distanceLabel = SKLabelNode(text: "")
        distanceLabel.name = HudLayerNode.runningDistanceLabelName
        
        distanceLabel.position = CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.89)
        distanceLabel.fontSize = 50
        addChild(distanceLabel)
        updateRunningDistanceLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateRunningDistanceLabel), name: HudLayerNode.runningDistanceUpdateNotification, object: nil)
    }
    
    fileprivate func prepareAchievementsMultiplierLabel() {
        let achievementsLabel = SKLabelNode(text: "57x")
        achievementsLabel.name = HudLayerNode.achievementsLabelName
        
        achievementsLabel.position = CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.8)
        achievementsLabel.fontSize = 50
        addChild(achievementsLabel)
        updateAchievementsLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateRunningDistanceLabel), name: HudLayerNode.achievementsUpdateNotification, object: nil)
    }
    
    fileprivate func prepareEnergyBar() {
        let progressIndicator = ProgressIndicatorNode(with: ProgressIndicatorNode.hudSize, borderWidth: ProgressIndicatorNode.hudBorderWidth)
        progressIndicator.name = HudLayerNode.energyBarName
        progressIndicator.position = CGPoint(x: progressIndicator.size.width / 2 + progressIndicator.size.height * 2,
                                             y: screenSize.height * 0.92)
        addChild(progressIndicator)
        updateEnergyBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateRunningDistanceLabel), name: HudLayerNode.energyBarUpdateNotification, object: nil)
    }
    
    func prepareCoinsLabel() {
        let coinsLabel = SKLabelNode.iconLabelNode(withText: "00000000", iconNamed: "")
        coinsLabel.name = HudLayerNode.coinsLabelName
        coinsLabel.position = CGPoint(x: coinsLabel.frame.width / 2 + coinsLabel.frame.height * 2,
                                      y: screenSize.height * 0.8)
        addChild(coinsLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCoinsLabel), name: HudLayerNode.coinsLabelUpdateNotification, object: nil)
    }
    
    func prepareMusicControlButton() {
        let musicButton = SKButtonNode.musicControlButton { print("music button FTW!!!") }
        addChild(musicButton)
        musicButton.position = CGPoint(x: screenSize.width  - SKButtonNode.hudButtonSize.width * 3.6, y: screenSize.height - SKButtonNode.hudButtonSize.width * 1.2)
    }

    func preparePauseButton() {
        let pauseButton = SKButtonNode.pauseButton { print("pause button FTW!!!") }
        addChild(pauseButton)
        pauseButton.position = CGPoint(x: screenSize.width  - SKButtonNode.hudButtonSize.width * 2.4, y: screenSize.height - SKButtonNode.hudButtonSize.width * 1.2)
    }
    
    func prepareSFXControlButton() {
        let sfxButton = SKButtonNode.sfxControlButton { print("sfx button FTW!!!") }
        addChild(sfxButton)
        sfxButton.position = CGPoint(x: screenSize.width - SKButtonNode.hudButtonSize.width * 1.2 , y: screenSize.height - SKButtonNode.hudButtonSize.height * 1.2)
    }
    
    private var screenSize : CGSize {
        return GameManager.shared.skView.frame.size.scaled()
    }
}

//MARK: - HUD Update

extension HudLayerNode {
    
    func updateRunningDistanceLabel() {
        let label = childNode(withName: HudLayerNode.runningDistanceLabelName) as? SKLabelNode
        
        guard let endlessLevelScene = label?.scene as? EndlessLevelScene else { return }
        label?.text = "\(endlessLevelScene.scores.runningDistance) m"
    }
    
    func updateAchievementsLabel() {
        let label = childNode(withName: HudLayerNode.achievementsLabelName) as? SKLabelNode
        
        guard let endlessLevelScene = label?.scene as? EndlessLevelScene else { return }
        label?.text = "\(endlessLevelScene.scores.achievementsCount) x"
    }
    
    func updateEnergyBar() {
        guard let progressIndicator = childNode(withName: HudLayerNode.energyBarName) as? ProgressIndicatorNode else { return }
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run { progressIndicator.progress = 0 },
                                                      SKAction.wait(forDuration: 2), SKAction.run { progressIndicator.progress = 1 }
            ])))
    }
    
    func updateCoinsLabel() {
        let label = childNode(withName: HudLayerNode.coinsLabelName) as? SKLabelNode
        guard let endlessLevelScene = label?.scene as? EndlessLevelScene else { return }
        label?.text = String(format:"%d", endlessLevelScene.scores.coins)
    }
}

//MARK: - HUD Touch Handling

extension HudLayerNode {
    func hudTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        let touchedNode = self.nodes(at: location).first as? SKButtonNode
        touchedNode?.fireAction()
    }
}
