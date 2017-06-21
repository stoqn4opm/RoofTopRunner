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
    
    //MARK: - Infinite Scrolling Helpers
    
    fileprivate var leftIndex: Int?
    fileprivate var rightIndex: Int?
    
    //MARK: - Properties
    
    var items: [MenuScrollItem]
    let itemsSpacing: CGFloat = 20
    let itemSize = CGSize(width: 150, height: 250)
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

        let numberOfEdges = 10
        var edgeLoops: [SKPhysicsBody] = []
        
        for i in 0...numberOfEdges {
            
            let sizeForEdge = size.scaled(at: 1.0 + CGFloat(i) / CGFloat(numberOfEdges))
            let originForEdge = CGPoint(x: (screenSize.width - sizeForEdge.width) / 2, y: (screenSize.height - sizeForEdge.height) / 2)
            let edge = SKPhysicsBody.init(edgeLoopFrom: CGRect(origin: originForEdge, size: sizeForEdge))
            edgeLoops.append(edge)
        }
        
        physicsBody = SKPhysicsBody(bodies: edgeLoops)
        physicsBody?.contactTestBitMask = MenuScrollingNode.itemContactTestBitMask
        physicsBody?.affectedByGravity = false
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
        
        let countOfIterations = Int((size.width - itemsSpacing) / (itemSize.width + itemsSpacing) - 1)
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
    }
    
    func sprite(forMenuItem menuItem: MenuScrollItem) -> SKSpriteNode {
        let item = SKSpriteNode(color: menuItem.color, size: itemSize)
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

//MARK: - Placing Items - Right

extension MenuScrollingNode {
    
    func placeAtRight() {
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        guard let rightIndex = self.rightIndex else { return }
        let newItem = sprite(forMenuItem: getItemAtIndex(rightIndex))
     
        guard let menuItemOnFarRight = self.positionOfMenuItemOnFarRight else { return }
        
        let xCoord = menuItemOnFarRight.position.x + itemsSpacing + newItem.size.width
        newItem.position = CGPoint(x: xCoord, y: screenSize.height / 2)
        newItem.name = "\(MenuScrollingNode.menuItemName)\(rightIndex)"
        movableArea.addChild(newItem)
        
        guard let newItemPhysicsBody = newItem.physicsBody else { return }
        guard let menuItemOnFarRightPhysicsBody = menuItemOnFarRight.physicsBody else { return }
        
        let j = SKPhysicsJointLimit.joint(withBodyA: newItemPhysicsBody, bodyB: menuItemOnFarRightPhysicsBody,
                                          anchorA: newItem.position, anchorB: menuItemOnFarRight.position)
        scene?.physicsWorld.add(j)
    }
    
    var positionOfMenuItemOnFarRight: SKNode? {
        guard let menuItems = self.menuItems else { return nil }
        var biggestCoords = menuItems[0]
        for item in menuItems {
            if item.position.x > biggestCoords.position.x {
                biggestCoords = item
            }
        }
        return biggestCoords
    }
}

//MARK: - Placing Items - Left

extension MenuScrollingNode {
    
    func placeAtLeft() {
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        guard let leftIndex = self.leftIndex else { return }
        let newItem = sprite(forMenuItem: getItemAtIndex(leftIndex))
        
        guard let menuItemOnFarLeft = self.positionOfMenuItemOnFarLeft else { return }
        
        let xCoord = menuItemOnFarLeft.position.x - itemsSpacing - newItem.size.width
        newItem.position = CGPoint(x: xCoord, y: screenSize.height / 2)
        newItem.name = "\(MenuScrollingNode.menuItemName)\(leftIndex)"
        movableArea.addChild(newItem)
        
        guard let newItemPhysicsBody = newItem.physicsBody else { return }
        guard let menuItemOnFarRightPhysicsBody = menuItemOnFarLeft.physicsBody else { return }
        
        let j = SKPhysicsJointLimit.joint(withBodyA: newItemPhysicsBody, bodyB: menuItemOnFarRightPhysicsBody,
                                          anchorA: newItem.position, anchorB: menuItemOnFarLeft.position)
        scene?.physicsWorld.add(j)
    }
    
    var positionOfMenuItemOnFarLeft: SKNode? {
        guard let menuItems = self.menuItems else { return nil }
        var smallestCoords = menuItems[0]
        for item in menuItems {
            if item.position.x < smallestCoords.position.x {
                smallestCoords = item
            }
        }
        return smallestCoords
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

//MARK: - Spawning / Destroying

extension MenuScrollingNode {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nameOfBodyA = contact.bodyA.node?.name else { return }
        guard let nameOfBodyB = contact.bodyB.node?.name else { return }
        
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        
        guard let rightIndex = self.rightIndex else { return }
        guard let leftIndex = self.leftIndex else { return }
        
        if nameOfBodyA == "scroll" && nameOfBodyB.hasPrefix(MenuScrollingNode.menuItemName) {
            guard let bodyToBeRemoved = contact.bodyB.node else { return }
            
            if convert(bodyToBeRemoved.position, from: movableArea).x < screenSize.width / 2  {
                self.rightIndex = rightIndex + 1
                self.leftIndex = leftIndex + 1
                placeAtRight()
            } else {
                self.rightIndex = rightIndex - 1
                self.leftIndex = leftIndex - 1
                placeAtLeft()
            }
            contact.bodyB.node?.removeFromParent()
        }
        else if nameOfBodyB == "scroll" && nameOfBodyA.hasPrefix(MenuScrollingNode.menuItemName) {
            guard let bodyToBeRemoved = contact.bodyA.node else { return }
            
            if convert(bodyToBeRemoved.position, from: movableArea).x < screenSize.width / 2  {
                self.rightIndex = rightIndex + 1
                self.leftIndex = leftIndex + 1
                placeAtRight()
            } else {
                self.rightIndex = rightIndex - 1
                self.leftIndex = leftIndex - 1
                placeAtLeft()
            }
            
            contact.bodyA.node?.removeFromParent()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) { }
}

//MARK: - Update Loop

extension MenuScrollingNode {
    func update(_ currentTime: TimeInterval) {
        moveByInertiaAllMenuItems()
        scaleInAccordanceToLocationAllMenuItems()
    }
    
    func scaleInAccordanceToLocationAllMenuItems() {
        guard let movableArea = childNode(withName: MenuScrollingNode.movableAreaName) else { return }
        guard let menuItems = self.menuItems as? [SKSpriteNode] else { return }
        
        
        for item in menuItems {
            let positionInSelf = convert(item.position, from: movableArea)
            let scale = scaleFactorFor(x: positionInSelf.x)
            print("scale \(scale)")
            item.xScale = scale //positionInSelf.x.truncatingRemainder(dividingBy: 50.0) / 50
            item.yScale = scale //positionInSelf.x.truncatingRemainder(dividingBy: 50.0) / 50
        }
    }
    
    func scaleFactorFor(x: CGFloat) -> CGFloat {
        
        guard let scene = self.scene else { return 1 }
        
        let x1 = CGFloat(0.0)
        let x2 = scene.size.width
        let x0 = scene.size.width / 2
        
        let coefA = 5.0 / ((x0 - x2) * (x0 + x1 + 2.0 * x2))
        let coefB = -coefA * (x1 + x2)
        let coefC = -coefA * x2 * x2 - coefB * x2
        
        return coefA * (x*x) + coefB * x + coefC
    }
    
    func moveByInertiaAllMenuItems() {
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
    
    func getItemAtIndex(_ index: Int) -> MenuScrollItem {
        var index = Int(Double(index).truncatingRemainder(dividingBy: Double(items.count)))
        if index < 0 { index = items.count + index }
        return items[index]
    }
}
