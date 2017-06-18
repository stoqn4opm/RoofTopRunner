//
//  MainMenuScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/18/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var speedOfMovement: CGFloat = 0.0
    var oldPosition: CGFloat = 0.0
    var lastTimeOfMethodCall = DispatchTime.now().rawValue
    
    override func didMove(to view: SKView) {
        
        let scrollMenu = MenuScrollingNode(withSize: CGSize(width: 600, height: 600), items:
            [MenuScrollItem(),MenuScrollItem()])
        scrollMenu.name = "scroll"
        addChild(scrollMenu)
        scrollMenu.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let menu = childNode(withName: "scroll") as? MenuScrollingNode
        menu?.menuTouchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let menu = childNode(withName: "scroll") as? MenuScrollingNode
        menu?.menuTouchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let menu = childNode(withName: "scroll") as? MenuScrollingNode
        menu?.menuTouchesEnded(touches, with: event)
    }
}

















extension MainMenuScene {

    func node() {
        
        // Create Label node and add it to the scrolling node to see it
        let box = SKSpriteNode(texture: nil, color: .green, size: CGSize(width: 100, height: 100))
        box.position = CGPoint(x: size.width / 2, y: size.height / 2)
        box.name = "movableArea"
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.mass = 0.0000001
        box.physicsBody?.linearDamping = 0.8
        addChild(box)

    }
}
