//
//  ScrapeBoard.swift
//  RunAway
//
//  Created by Stoyan Stoyanov on 9/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

//MARK: - Delegate

@objc protocol ScrapableBoardDelegate {
    func didScrapeBoard(_ board: ScrapableBoard)
}

class ScrapableBoard: SKCropNode {
    
    //MARK: - Properties
    
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
}

//MARK: - Scraping

extension ScrapableBoard {
    
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
    
    fileprivate func placeMaskFillerIfNeededAt(_ position: CGPoint) {
        
        guard let mask = maskNode else { return }
        
        guard mask.atPoint(position) == mask else { return }
        
        let maskFiller = SKSpriteNode(color: .white, size: ScrapableBoard.brushSize)
        maskFiller.position = position
        mask.addChild(maskFiller)
        lastTouchCoord = position
    }
}

//MARK: - Scraping Finished

extension ScrapableBoard {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isScraped { delegate?.didScrapeBoard(self) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isScraped { delegate?.didScrapeBoard(self) }
    }
    
    fileprivate var isScraped: Bool {
        
        guard let mask = maskNode else { return false }
        guard let board = childNode(withName: "gameBoard") as? SKSpriteNode else { return false }
        
        let gridSize = ScrapableBoard.brushSize.scaled(at: 0.5)
        
        let horSteps = Int(board.size.width / gridSize.width)
        let verSteps = Int(board.size.height / gridSize.height)
        
        let upperLeftCoord = CGPoint(x: -board.size.width / 2, y: board.size.height / 2)
        
        var unscrapedPlaces = 0.0
        
        for horStep in 0...horSteps {
            for verStep in 0...verSteps {
                let examinePoint = CGPoint(x: upperLeftCoord.x + (CGFloat(horStep) + 0.25) * gridSize.width,
                                           y: upperLeftCoord.y - (CGFloat(verStep) + 0.25) * gridSize.height)
                
                if mask.atPoint(examinePoint) == mask {
                    unscrapedPlaces += 1
                }
            }
        }

        if unscrapedPlaces < Double((horSteps + 1) * (verSteps + 1)) * 0.15 {
            maskNode = nil
            return true
        } else {
            return false
        }
    }
}
