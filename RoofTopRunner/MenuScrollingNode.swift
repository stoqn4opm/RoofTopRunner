//
//  MenuScrollingNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/18/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

struct MenuScrollItem {
    
}

class MenuScrollingNode: SKNode {

    //MARK: - Static Properties
    
    static let movableAreaName = "MovableAreaName"
    static let MenuItemName = "MenuItemNameName"

    //MARK: - Internal Inertia Helpers
    
    fileprivate var speedOfMovement: CGFloat = 0.0
    fileprivate var oldPosition: CGFloat = 0.0
    fileprivate var lastTimeOfStoringSpeed = DispatchTime.now().rawValue
    fileprivate var initialDistance = CGFloat(0.0)
    
    //MARK: - Properties
    
    let items: [MenuScrollItem]
    let itemsSpacing: CGFloat = 20
    let itemSize = CGSize(width: 100, height: 100)
    let size: CGSize
    
    //MARK: - Initializers
    
    init(withSize size: CGSize, items: [MenuScrollItem]) {
        self.size = size
        self.items = items
        super.init()
        self.physicsBody = SKPhysicsBody.init(edgeLoopFrom: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size))
        layoutItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Initial Items Layout

extension MenuScrollingNode {
    
    func layoutItems() {
    
        let movableArea = SKNode()
        movableArea.name = MenuScrollingNode.movableAreaName
        addChild(movableArea)
        
        for itemIndex in 0..<items.count {
            
            let item = sprite(for: items[itemIndex], inside: movableArea)
            let xCoord = itemIndex == 0 ? itemsSpacing : itemsSpacing + CGFloat(itemIndex) * (itemSize.width + itemsSpacing)
            item.position = CGPoint(x: -size.width / 2 + xCoord, y: 0)
            item.name = "\(MenuScrollingNode.MenuItemName)\(itemIndex)"
        }
    }
    
    func sprite(for menuItem: MenuScrollItem, inside movableArea: SKNode) -> SKSpriteNode {
        let item = SKSpriteNode(color: .brown, size: itemSize)
        item.anchorPoint = .normalizedLeft
        movableArea.addChild(item)
     
        item.physicsBody = SKPhysicsBody(rectangleOf: itemSize, center: CGPoint(x: item.size.width / 2, y: 0))
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.mass = 0.0000001
        item.physicsBody?.linearDamping = 1
        item.physicsBody?.allowsRotation = false
        
        return item
    }
}

//MARK: - Touch Handling

extension MenuScrollingNode {
    
    func menuTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let position = touches.first?.location(in: self) else { return }
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        
        initialDistance = movableArea.position.x - position.x
        removeAllLeftOverInertia()
        calculateSpeed()
    }
    
    func menuTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        
        movableArea.position = CGPoint(x: position.x + initialDistance, y: movableArea.position.y)
        calculateSpeed()
    }
    
    func menuTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let items = menuItems {
            for item in items {
                item.physicsBody?.applyImpulse(CGVector(dx: speedOfMovement, dy: 0))
            }
        }
    }
}

//MARK: - Helpers

extension MenuScrollingNode {
    
    func removeAllLeftOverInertia() {
        guard let items = menuItems else { return }
        for item in items {
            item.physicsBody?.isResting = true
        }
    }
    
    func calculateSpeed() {
        let now = DispatchTime.now().rawValue
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        speedOfMovement = (movableArea.position.x - oldPosition) / CGFloat(now - lastTimeOfStoringSpeed)
        
        oldPosition = movableArea.position.x
        lastTimeOfStoringSpeed = now
    }
    
    var menuItems: [SKNode]? {
        
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return nil }
        let items = movableArea.children.filter({ (child: SKNode) -> Bool in
            
            guard let name = child.name else { return false }
            return name.hasPrefix(MenuScrollingNode.MenuItemName)
        })
        return items
    }
}
