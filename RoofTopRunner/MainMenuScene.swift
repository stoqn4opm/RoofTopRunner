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
        
        physicsWorld.contactDelegate = self
        
        let scrollMenu = MenuScrollingNode(withSize: CGSize(width: 900, height: 600), items:
            [MenuScrollItem(color: .brown),
             MenuScrollItem(color: .green),
             MenuScrollItem(color: .yellow)])
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

extension MainMenuScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let menu = childNode(withName: "scroll") as? MenuScrollingNode
        menu?.didBegin(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let menu = childNode(withName: "scroll") as? MenuScrollingNode
        menu?.didEnd(contact)
    }
}

extension MainMenuScene {
    override func update(_ currentTime: TimeInterval) {
        let menu = childNode(withName: "scroll") as? MenuScrollingNode
        menu?.update(currentTime)
    }
}
