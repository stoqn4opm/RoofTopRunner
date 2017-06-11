//
//  SKButtonNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/9/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class SKButtonNode: SKSpriteNode {
    
    //MARK: - Static Properties
    
    static let hudButtonSize = CGSize(width: 100, height: 100)
    
    //MARK: - Properties
    
    var action: (Void) -> Void
    
    //MARK: - Initializer
    
    init(withImageName imageName: String, size: CGSize, action: @escaping (Void) -> Void) {
        self.action = action
        super.init(texture: nil, color: .cyan, size: size)
        self.anchorPoint = .normalizedLowerLeft
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Action Firing

extension SKButtonNode {
    
    func fireAction() {
        action()
    }
}
