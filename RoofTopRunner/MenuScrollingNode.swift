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
    static let menuItemName = "MenuItemName"
    static let itemContactTestBitMask: UInt32 = 0b000000000001
    static let snapBackDuration: TimeInterval = 1
    
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
        setupPhysicsEdge()
        layoutItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Physics Edge

extension MenuScrollingNode {
    
    func setupPhysicsEdge() {
        let origin = CGPoint(x: (screenSize.width - size.width) / 2, y: (screenSize.height - size.height) / 2)
        physicsBody = SKPhysicsBody.init(edgeLoopFrom: CGRect(origin: origin, size: size))
        physicsBody?.contactTestBitMask = MenuScrollingNode.itemContactTestBitMask
    }
}

//MARK: - Initial Items Layout

extension MenuScrollingNode {
    
    func layoutItems() {
    
        let movableArea = SKNode()
        movableArea.name = MenuScrollingNode.movableAreaName
        addChild(movableArea)
        
        let marker = SKSpriteNode(color: .red, size: CGSize(width: 5, height: 200))
        marker.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        addChild(marker)
        
        for itemIndex in 0..<items.count {
            
            let item = sprite(for: items[itemIndex], inside: movableArea)
            let xCoord = itemIndex == 0 ? itemsSpacing : itemsSpacing + CGFloat(itemIndex) * (itemSize.width + itemsSpacing)
            item.position = CGPoint(x: (-size.width / 2 + xCoord) + screenSize.width / 2, y: screenSize.height / 2)
            item.name = "\(MenuScrollingNode.menuItemName)\(itemIndex)"
        }
    }
    
    func sprite(for menuItem: MenuScrollItem, inside movableArea: SKNode) -> SKSpriteNode {
        let item = SKSpriteNode(color: menuItem.color, size: itemSize)
        item.anchorPoint = .normalizedMiddle
        movableArea.addChild(item)
     
        item.physicsBody = SKPhysicsBody(rectangleOf: itemSize, center: .zero)
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.mass = 0.0000001
        item.physicsBody?.linearDamping = 5
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
        
        guard let items = menuItems else { return }
        for item in items { item.physicsBody?.applyImpulse(CGVector(dx: speedOfMovement, dy: 0)) }
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
            thereWasInitialTouch = false
            
            guard let scene = self.scene else { return }
            guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
            guard let menuItems = self.menuItems as? [SKSpriteNode] else { return }
            
            var closestItem = CGFloat(1000000)
            var wasOnLeft = false
            
            for item in menuItems {
                
                let positionInSelf = convert(item.position, from: movableArea)
                
                let distanceFromCenter = abs(positionInSelf.x - scene.size.width / 2)
                if distanceFromCenter < closestItem {
                    closestItem = distanceFromCenter
                    wasOnLeft = positionInSelf.x - scene.size.width / 2 < 0 ? true : false
                }
            }
            
            let translationAmmount = wasOnLeft ? closestItem : -closestItem
            let translationAction = SKAction.move(by: CGVector(dx: translationAmmount, dy: 0), duration: MenuScrollingNode.snapBackDuration)
            translationAction.timingFunction = {
                let time: Float = $0
                return time<0.5 ? 2*time*time : -1+(4-2*time)*time
            }
            movableArea.run(translationAction)
        }
    }
}

//MARK: - Helpers

extension MenuScrollingNode {
    
    fileprivate var screenSize : CGSize {
        return GameManager.shared.skView.frame.size.scaled()
    }
    
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
