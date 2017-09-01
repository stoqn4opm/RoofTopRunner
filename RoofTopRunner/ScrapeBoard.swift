//
//  ScrapeBoard.swift
//  RunAway
//
//  Created by Stoyan Stoyanov on 9/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

@objc protocol ScrapableBoardDelegate {
    func didScrapeBoard(_ board: ScrapableBoard)
}

class ScrapableBoard: SKCropNode {
    
    static var brushSize = CGSize(width: 100, height: 100)
    
    weak var delegate: ScrapableBoardDelegate?
    
    
    fileprivate var lastTouchCoord: CGPoint?
    
    override init() {
        super.init()
        maskNode = SKNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        guard let mask = maskNode else { return }
        
        
        let positionInCropNode = touch.location(in: self)
        
        if let lastPosition = lastTouchCoord {
            
            let deltaX = abs(positionInCropNode.x - lastPosition.x)
            let deltaY = abs(positionInCropNode.y - lastPosition.y)
            let squaredSum = pow(deltaX, 2) + pow(deltaY, 2)
            let distance = sqrt(squaredSum)
            
            if distance > ScrapableBoard.brushSize.width / 2 + 10 {
                let positionInRegardsToMask = convert(positionInCropNode, to: mask)
                placeMaskFillerIfNeededAt(positionInRegardsToMask)
            }
            
        } else {
            
            let maskFiller = SKSpriteNode(color: .white, size: ScrapableBoard.brushSize)
            maskFiller.position = convert(positionInCropNode, to: mask)
            mask.addChild(maskFiller)
            lastTouchCoord = positionInCropNode
        }
    }
}


extension ScrapableBoard {
    
    fileprivate func placeMaskFillerIfNeededAt(_ position: CGPoint) {
        
        guard let mask = maskNode else { return }
        
        guard mask.atPoint(position) == mask else { return }
        
//        let testPoints = [position,
//                          CGPoint(x: position.x - (3 / 4) * ScrapableBoard.brushSize.width, y: position.y + (3 / 4) * ScrapableBoard.brushSize.height),
//                          CGPoint(x: position.x + (3 / 4) * ScrapableBoard.brushSize.width, y: position.y + (3 / 4) * ScrapableBoard.brushSize.height),
//                          CGPoint(x: position.x + (3 / 4) * ScrapableBoard.brushSize.width, y: position.y - (3 / 4) * ScrapableBoard.brushSize.height),
//                          CGPoint(x: position.x - (3 / 4) * ScrapableBoard.brushSize.width, y: position.y - (3 / 4) * ScrapableBoard.brushSize.height)]
//        
//        var isScrapedOnAllTestPoints = true
//        for testPoint in testPoints {
//            if mask.atPoint(testPoint) == mask && mask.contains(<#T##p: CGPoint##CGPoint#>) {
//                isScrapedOnAllTestPoints = false
//                break
//            }
//        }
//        
//        if !isScrapedOnAllTestPoints {
//        
            let maskFiller = SKSpriteNode(color: .white, size: ScrapableBoard.brushSize)
            maskFiller.position = position
            mask.addChild(maskFiller)
            lastTouchCoord = position
//        }
    
    }
}
