//
//  MenuScrollingNode.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/18/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

struct MenuScrollItem {
    let imageName: String
    let action: (Void) -> Void
}

class MenuScrollingNode: SKNode {
    
    //MARK: - Static Properties
    static let menuScrollingNodeName = "MenuScrollingNodeName"
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
    
    //MARK: - Button Helpers
    
    fileprivate var positionOfMovableAreaOnTochesBegin: CGPoint?
    fileprivate var positionOfMovableAreaOnTochesEnd: CGPoint?
    
    //MARK: - Infinite Scrolling Helpers
    
    fileprivate var leftIndex: Int?
    fileprivate var rightIndex: Int?
    
    //MARK: - Properties
    
    var items: [MenuScrollItem]
    fileprivate var itemsSpacing: CGFloat { return screenSize.width / -33.35 }
    fileprivate var itemSize: CGSize { return CGSize(width: screenSize.width / 3.335, height: screenSize.height / 2.343) }
    fileprivate let size: CGSize
    
    //MARK: - Initializers
    
    init(withSize size: CGSize, items: [MenuScrollItem]) {
        self.size = size
        self.items = items
        super.init()
        name = MenuScrollingNode.menuScrollingNodeName
        layoutItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Initial Items Layout

extension MenuScrollingNode {
    
    fileprivate func layoutItems() {

        let movableArea = SKNode()
        movableArea.name = MenuScrollingNode.movableAreaName
        addChild(movableArea)

        let countOfIterations = Int((size.width - itemsSpacing) / (itemSize.width + itemsSpacing) - 0)
        for itemIndex in 0..<countOfIterations {
            
            let item = sprite(forMenuItem: getItemAtIndex(itemIndex))
            let xCoord = itemIndex == 0 ? itemsSpacing + itemSize.width / 2 : itemsSpacing + CGFloat(itemIndex) * (itemSize.width + itemsSpacing) + itemSize.width / 2
            item.position = CGPoint(x: (-size.width / 2 + xCoord) + screenSize.width / 2, y: screenSize.height / 2)
            item.name = "\(MenuScrollingNode.menuItemName)\(itemIndex)"
            movableArea.addChild(item)
            
            if itemIndex == countOfIterations - 1 {
                leftIndex = 0
                rightIndex = itemIndex
            }
        }
        
        snapClosestMenuItemToCenterWithDuration(0)
    }
    
    fileprivate func sprite(forMenuItem menuItem: MenuScrollItem) -> SKSpriteNode {
        let item = SKButtonNode(withImageName: menuItem.imageName, size: itemSize, action: menuItem.action)
        item.anchorPoint = .normalizedMiddle
        
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

//MARK: - Spawning New Items

extension MenuScrollingNode {
    
    fileprivate func placeItem(onLeft : Bool) {
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        guard let index = onLeft ? leftIndex : rightIndex else { return }
        let newItem = sprite(forMenuItem: getItemAtIndex(index))
        guard let boundaryMenuItem = boundaryMenuItem(onLeft: onLeft) else { return }
        
        let offset = itemsSpacing + newItem.size.width
        let xCoord = boundaryMenuItem.position.x + (onLeft ? -offset : offset)
        newItem.position = CGPoint(x: xCoord, y: screenSize.height / 2)
        newItem.name = "\(MenuScrollingNode.menuItemName)\(index)"
        
        let positionInSelf = convert(newItem.position, from: movableArea)
        let scale = scaleFactorFor(x: positionInSelf.x)
        applyScale(scale, for: newItem)
        
        movableArea.addChild(newItem)
        
        guard let newItemPhysicsBody = newItem.physicsBody else { return }
        guard let boundaryMenuItemPhysicsBody = boundaryMenuItem.physicsBody else { return }
        
        let limitJoint = SKPhysicsJointLimit.joint(withBodyA: newItemPhysicsBody, bodyB: boundaryMenuItemPhysicsBody,
                                                   anchorA: newItem.position, anchorB: boundaryMenuItem.position)
        scene?.physicsWorld.add(limitJoint)
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
        positionOfMovableAreaOnTochesBegin = movableArea.position
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
        
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        positionOfMovableAreaOnTochesEnd = movableArea.position
        
        guard let items = menuItems else { return }
        for item in items { item.physicsBody?.applyImpulse(CGVector(dx: speedOfMovement, dy: 0)) }
        fireButtonActionIfNeeded(from: touches)
    }
}

//MARK: - Update Loop

extension MenuScrollingNode {
    func update(_ currentTime: TimeInterval) {
        alignMenuItemsIfNeeded()
        scaleInAccordanceToLocationAllMenuItems()
        spawnOrRemoveMenuItems()
        applyAlphaInAccordanceToLocationAllMenuItems()
    }
}

//MARK: - Spawning/Removing MenuItems

extension MenuScrollingNode {
    
    fileprivate func spawnOrRemoveMenuItems() {
        
        guard let rightIndex = self.rightIndex else { return }
        guard let leftIndex = self.leftIndex else { return }
        
        let leftMargin = (screenSize.width - size.width) / 2
        let rightMargin = (screenSize.width + size.width) / 2
        
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        guard let menuItems = self.menuItems as? [SKSpriteNode] else { return }
        
        for item in menuItems {
            let positionInSelf = convert(item.position, from: movableArea)
            if positionInSelf.x > rightMargin {
                self.rightIndex = rightIndex - 1
                self.leftIndex = leftIndex - 1
                placeItem(onLeft: true)
                item.removeFromParent()
            } else if positionInSelf.x < leftMargin {
                self.rightIndex = rightIndex + 1
                self.leftIndex = leftIndex + 1
                placeItem(onLeft: false)
                item.removeFromParent()
            }
        }
    }
}

//MARK: - Scaling

extension MenuScrollingNode {
    
    fileprivate func scaleInAccordanceToLocationAllMenuItems() {
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        guard let menuItems = self.menuItems as? [SKSpriteNode] else { return }
        
        
        for item in menuItems {
            let positionInSelf = convert(item.position, from: movableArea)
            let scale = scaleFactorFor(x: positionInSelf.x)
            applyScale(scale, for: item)
        }
    }
    
    fileprivate func applyScale(_ scale: CGFloat, for item: SKNode) {
        item.xScale = scale
        item.yScale = scale
    }
    
    fileprivate func scaleFactorFor(x: CGFloat) -> CGFloat {
        guard let scene = self.scene else { return 1 }
        return 1 / (1 / (screenSize.width / 0.00667) * abs(pow(x - scene.size.width / 2, 2.0)) + 1)
    }
}

//MARK: - Inertia

extension MenuScrollingNode {
    
    fileprivate func alignMenuItemsIfNeeded() {
        guard let itemBody = menuItems?.first?.physicsBody else { return }
        
        if itemBody.isResting && !isMoving && thereWasInitialTouch {
            thereWasInitialTouch = false
            snapClosestMenuItemToCenterWithDuration(MenuScrollingNode.snapBackDuration)
        }
    }
    
    fileprivate func snapClosestMenuItemToCenterWithDuration(_ duration: TimeInterval) {
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        guard let menuItems = self.menuItems as? [SKSpriteNode] else { return }
        
        var closestItem = CGFloat(1000000)
        var wasOnLeft = false
        
        for item in menuItems {
            
            let positionInSelf = convert(item.position, from: movableArea)
            
            let distanceFromCenter = abs(positionInSelf.x - self.screenSize.width / 2)
            if distanceFromCenter < closestItem {
                closestItem = distanceFromCenter
                wasOnLeft = positionInSelf.x - self.screenSize.width / 2 < 0 ? true : false
            }
        }
        
        let translationAmmount = wasOnLeft ? closestItem : -closestItem
        let translationAction = SKAction.move(by: CGVector(dx: translationAmmount, dy: 0), duration: duration)
        translationAction.timingFunction = {
            let time: Float = $0
            return time<0.5 ? 2*time*time : -1+(4-2*time)*time
        }
        movableArea.run(translationAction)
    }
    
    fileprivate func removeAllLeftOverInertia() {
        guard let items = menuItems else { return }
        for item in items {
            item.physicsBody?.isResting = true
        }
    }
}

//MARK: - Fade Out

extension MenuScrollingNode {
    
    fileprivate func applyAlphaInAccordanceToLocationAllMenuItems() {
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        guard let menuItems = self.menuItems as? [SKSpriteNode] else { return }
        
        for item in menuItems {
            let positionInSelf = convert(item.position, from: movableArea)
            let alpha = alphaFor(x: positionInSelf.x)
            item.alpha = alpha
        }
    }
    
    fileprivate func alphaFor(x: CGFloat) -> CGFloat {
        guard let scene = self.scene else { return 1 }
        return -1 / (screenSize.width / 0.004446666)  * pow(x - scene.size.width / 2, 2.0) + 1
    }
}

//MARK: - Helpers

extension MenuScrollingNode {
    
    fileprivate var screenSize : CGSize {
        return GameManager.shared.skView.frame.size.scaled()
    }
    
    fileprivate func calculateSpeed() {
        let now = DispatchTime.now().rawValue
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        speedOfMovement = (movableArea.position.x - oldPosition) / CGFloat(now - lastTimeOfStoringSpeed)
        oldPosition = movableArea.position.x
        lastTimeOfStoringSpeed = now
    }
    
    fileprivate var menuItems: [SKNode]? {
        
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return nil }
        let items = movableArea.children.filter({ (child: SKNode) -> Bool in
            
            guard let name = child.name else { return false }
            return name.hasPrefix(MenuScrollingNode.menuItemName)
        })
        return items
    }
    
    fileprivate func getItemAtIndex(_ index: Int) -> MenuScrollItem {
        var index = Int(Double(index).truncatingRemainder(dividingBy: Double(items.count)))
        if index < 0 { index = items.count + index }
        return items[index]
    }
    
    fileprivate func boundaryMenuItem(onLeft: Bool) -> SKNode? {
        guard let menuItems = self.menuItems else { return nil }
        var resultItem = menuItems[0]
        for item in menuItems {
            if onLeft {
                if item.position.x < resultItem.position.x { resultItem = item }
            } else {
                if item.position.x > resultItem.position.x { resultItem = item }
            }
        }
        return resultItem
    }
    
    fileprivate func fireButtonActionIfNeeded(from touches: Set<UITouch>) {
        
        guard let positionOfMovableAreaOnTochesBegin = self.positionOfMovableAreaOnTochesBegin else { return }
        guard let positionOfMovableAreaOnTochesEnd = self.positionOfMovableAreaOnTochesEnd else { return }
        guard abs(positionOfMovableAreaOnTochesBegin.x - positionOfMovableAreaOnTochesEnd.x) < itemSize.width / 4 else { return }
        
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        guard let touchedNode = self.nodes(at: location).first as? SKButtonNode else { return }
        
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        let positionInSelf = convert(touchedNode.position, from: movableArea)
        let distanceFromCenter = abs(positionInSelf.x - screenSize.width / 2)
        
        if distanceFromCenter < itemSize.width / 2 { touchedNode.fireAction() }
    }
}
