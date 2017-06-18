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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let position = touches.first!.location(in: self)
        let movableArea = childNode(withName: "movableArea")!
        movableArea.position = CGPoint(x: position.x, y: movableArea.position.y)
        
        let now = DispatchTime.now().rawValue
        
        speedOfMovement = (movableArea.position.x - oldPosition) / CGFloat(now - lastTimeOfMethodCall)
        
        oldPosition = movableArea.position.x
        lastTimeOfMethodCall = now
        
        print("speed \(speedOfMovement)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let movableArea = childNode(withName: "movableArea") as! SKSpriteNode
  
        movableArea.physicsBody?.applyImpulse(CGVector(dx: speedOfMovement, dy: 0))
        print("applied speed \(speedOfMovement)")
        speedOfMovement = 0
        
    }
}
