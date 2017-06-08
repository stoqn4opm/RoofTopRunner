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
    
    //MARK: - Initializers
    
    override init() {
        super.init()
        prepareRunningDistanceLabel()
        prepareAchievementsMultiplierLabel()
        prepareProgressIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: HudLayerNode.runningDistanceUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: HudLayerNode.achievementsUpdateNotification, object: nil)
    }
}

//MARK: - Labels Preparation

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
    
    fileprivate func prepareProgressIndicator() {
        let p = ProgressIndicatorNode(with: ProgressIndicatorNode.hudSize,
                                      borderWidth: ProgressIndicatorNode.hudBorderWidth,
                                      progress: 0.2)
        addChild(p)
        
        p.position = CGPoint(x: 400, y: screenSize.height * 0.92)
     
        
        run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run { p.progress = 0.5 }, SKAction.wait(forDuration: 2), SKAction.run { p.progress = 1 }
            ]))
    }
    
    private var screenSize : CGSize {
        return GameManager.shared.skView.frame.size.scaled()
    }
}

//MARK: - Labels Update

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
}
