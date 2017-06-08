//
//  ProgressIndicatorNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/8/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class ProgressIndicatorNode: SKSpriteNode {
    
    static let foregroundColor = UIColor.blue
    static let backgroundColor = UIColor.darkGray
    static let borderColor = UIColor.white
    static let borderWidth: CGFloat = 10
    
    static let hudSize = CGSize(width: 280, height: 50)
    static let hudBorderWidth: CGFloat = 7
    
    fileprivate let progressLineContainerName = "ProgressLineContainerName"
    
    init(with size: CGSize, borderWidth: CGFloat, progress: Double) {
        super.init(texture: nil, color: ProgressIndicatorNode.borderColor, size: size)
        
        let progressLineContainer = SKSpriteNode(color: ProgressIndicatorNode.backgroundColor,
                                                 size: CGSize(width: size.width - 2 * borderWidth,
                                                              height: size.height - 2 * borderWidth))
        
        progressLineContainer.name = progressLineContainerName
        let progressLine = ProgressLineNode(with: progressLineContainer.size, progress: progress)
        progressLineContainer.addChild(progressLine)
        progressLine.position = CGPoint(x: -progressLineContainer.size.width / 2, y: 0)
        addChild(progressLineContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var progress: Double {
        get {
            guard let lineContainer = childNode(withName: progressLineContainerName) as? SKSpriteNode else { return 0 }
            guard let line = lineContainer.childNode(withName: ProgressLineNode.lineName) as? ProgressLineNode else { return 0 }
            return Double(line.xScale)
        }
        set {
            guard let lineContainer = childNode(withName: progressLineContainerName) as? SKSpriteNode else { return }
            guard let line = lineContainer.childNode(withName: ProgressLineNode.lineName) as? ProgressLineNode else { return }
            let updateAction = SKAction.scaleX(to: CGFloat(newValue), duration: 0.5)
            updateAction.timingMode = .easeInEaseOut
            line.run(updateAction)
        }
    }
}

fileprivate class ProgressLineNode: SKCropNode {
    
    static let lineName = "ProgressLineNode"
    
    init(with size: CGSize, progress: Double) {
        super.init()
        name = ProgressLineNode.lineName
        
        let mask = SKSpriteNode(color: .white, size: size)
        mask.anchorPoint = .normalizedLeft
        maskNode = mask
        
        let backgound = SKSpriteNode(color: ProgressIndicatorNode.foregroundColor, size: size)
        backgound.anchorPoint = .normalizedLeft
        addChild(backgound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
