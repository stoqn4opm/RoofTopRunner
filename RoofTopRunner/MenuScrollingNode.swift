//
//  MenuScrollingNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/18/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

struct MenuScrollItem {
    let color: UIColor
}

class MenuScrollingNode: SKNode {

    //MARK: - Static Properties
    
    static let movableAreaName = "MovableAreaName"
    static let menuItemName = "MenuItemNameName"
    static let itemContactTestBitMask: UInt32 = 0b000000000001
    static let magneticBitMask: UInt32 = 0b000000000010

    //MARK: - Internal Inertia Helpers
    
    fileprivate var speedOfMovement: CGFloat = 0.0
    fileprivate var oldPosition: CGFloat = 0.0
    fileprivate var lastTimeOfStoringSpeed = DispatchTime.now().rawValue
    fileprivate var initialDistance = CGFloat(0.0)
    
    fileprivate var isMoving: Bool = false
    fileprivate var thereWasInitialTouch: Bool = false
    
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
        physicsBody = SKPhysicsBody.init(edgeLoopFrom: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size))
        physicsBody?.contactTestBitMask = MenuScrollingNode.itemContactTestBitMask
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
        
        let marker = SKSpriteNode(color: .red, size: CGSize(width: 5, height: 200))
        addChild(marker)
        
        for itemIndex in 0..<items.count {
            
            let item = sprite(for: items[itemIndex], inside: movableArea)
            let xCoord = itemIndex == 0 ? itemsSpacing : itemsSpacing + CGFloat(itemIndex) * (itemSize.width + itemsSpacing)
            item.position = CGPoint(x: -size.width / 2 + xCoord, y: 0)
            item.name = "\(MenuScrollingNode.menuItemName)\(itemIndex)"
        }
    }
    
    func sprite(for menuItem: MenuScrollItem, inside movableArea: SKNode) -> SKSpriteNode {
        let item = SKSpriteNode(color: menuItem.color, size: itemSize)
        item.anchorPoint = .normalizedLeft
        movableArea.addChild(item)
     
        item.physicsBody = SKPhysicsBody(rectangleOf: itemSize, center: CGPoint(x: item.size.width / 2, y: 0))
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.mass = 0.0000001
        item.physicsBody?.linearDamping = 1
        item.physicsBody?.allowsRotation = false
        
        item.physicsBody?.collisionBitMask = 0
        item.physicsBody?.categoryBitMask = 0
        item.physicsBody?.contactTestBitMask = MenuScrollingNode.itemContactTestBitMask
        
        return item
    }
}

//MARK: - Touch Handling

extension MenuScrollingNode {
    
    func menuTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let position = touches.first?.location(in: self) else { return }
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        
        isMoving = true
        thereWasInitialTouch = true
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
        isMoving = false
        
        if let items = menuItems {
            for item in items {
                item.physicsBody?.applyImpulse(CGVector(dx: speedOfMovement, dy: 0))
            }
        }
    }
}

extension MenuScrollingNode {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}

extension MenuScrollingNode {
    func update(_ currentTime: TimeInterval) {
        guard let itemBody = menuItems?.first?.physicsBody else { return }
        
        if itemBody.isResting && !isMoving && thereWasInitialTouch {
            guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
            thereWasInitialTouch = false
            let translation = movableArea.position.x - position.x
            
            guard let menuItems = self.menuItems else { return }
            guard var closestItem = menuItems.first else { return }
            
            for item in menuItems {
                if abs(item.position.x - translation) < abs(closestItem.position.x - translation) {
                    closestItem = item
                }
            }
            
            let closestItemGlobalXCoord = closestItem.position.x + translation
            guard let scene = self.scene else { return }
            let translationAction = SKAction.move(by: CGVector(dx: -closestItemGlobalXCoord - scene.size.width / 2, dy: 0), duration: 1)
            
            movableArea.run(translationAction)
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
            return name.hasPrefix(MenuScrollingNode.menuItemName)
        })
        return items
    }
}
