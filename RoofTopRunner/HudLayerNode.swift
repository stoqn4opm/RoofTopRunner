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
    
    //MARK: - Initializers
    
    override init() {
        super.init()
        prepareRunningDistanceLabel()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRunningDistanceLabel), name: HudLayerNode.runningDistanceUpdateNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: HudLayerNode.runningDistanceUpdateNotification, object: nil)
    }
}

//MARK: - Labels Preparation

extension HudLayerNode {
    
    fileprivate func prepareRunningDistanceLabel() {
        let distanceLabel = SKLabelNode(text: "")
        distanceLabel.name = HudLayerNode.runningDistanceLabelName
        
        let size = GameManager.shared.skView.frame.size.scaled()
        distanceLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.9)
        distanceLabel.fontSize = 50
        addChild(distanceLabel)
        updateRunningDistanceLabel()
    }
}

//MARK: - Labels Update

extension HudLayerNode {
    
    func updateRunningDistanceLabel() {
        let label = childNode(withName: HudLayerNode.runningDistanceLabelName) as? SKLabelNode
        
        guard let endlessLevelScene = label?.scene as? EndlessLevelScene else { return }
        label?.text = "\(endlessLevelScene.scores.runningDistance) m"
    }
}
