//
//  ProgressIndicatorNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/8/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class ProgressIndicatorNode: SKSpriteNode {
    
    //MARK: - Static Properties
    
    static let foregroundColor = UIColor.blue
    static let backgroundColor = UIColor.darkGray
    static let borderColor = UIColor.white
    
    static let hudSize = CGSize(width: 280, height: 50)
    static let hudBorderWidth: CGFloat = 7
    
    //MARK: - Properties
    
    fileprivate let progressLineContainerName = "ProgressLineContainerName"
    
    //MARK: - Initialization
    
    init(with size: CGSize, borderWidth: CGFloat, progress: Double = 1.0) {
        super.init(texture: nil, color: ProgressIndicatorNode.borderColor, size: size)
        setupProgressLineContainer(with: size, borderWidth: borderWidth, progress: progress)
        
        let icon = SKSpriteNode(color: .red, size: CGSize(width: size.height, height: size.height).scaled(at: 1.3))
        icon.position = CGPoint(x: -icon.size.width * 0.8 - size.width / 2, y: 0)
        addChild(icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProgressLineContainer(with size: CGSize, borderWidth: CGFloat, progress: Double) {
        let progressLineContainer = SKSpriteNode(color: ProgressIndicatorNode.backgroundColor,
                                                 size: CGSize(width: size.width - 2 * borderWidth,
                                                              height: size.height - 2 * borderWidth))
        
        progressLineContainer.name = progressLineContainerName
        let progressLine = ProgressLineNode(with: progressLineContainer.size)
        progressLineContainer.addChild(progressLine)
        progressLine.position = CGPoint(x: -progressLineContainer.size.width / 2, y: 0)
        addChild(progressLineContainer)
        progressLine.xScale = CGFloat(progress)
    }
}

//MARK: - Updating Progress

extension ProgressIndicatorNode {
    
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

//MARK: - Helper Class

fileprivate class ProgressLineNode: SKCropNode {
    
    static let lineName = "ProgressLineNode"
    
    init(with size: CGSize) {
        super.init()
        name = ProgressLineNode.lineName
        
        let mask = SKSpriteNode(color: .white, size: size)
        mask.anchorPoint = .normalizedLeft
        maskNode = mask
        
        let line = SKSpriteNode(color: ProgressIndicatorNode.foregroundColor, size: size)
        line.anchorPoint = .normalizedLeft
        addChild(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
