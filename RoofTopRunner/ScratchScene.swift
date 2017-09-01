//
//  ScratchScene.swift
//  RunAway
//
//  Created by Stoyan Stoyanov on 8/31/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class ScratchScene: SKScene {

    //MARK: - Properties
    
    let boardSize = CGSize(width: 5, height: 5)
    let desiredConsecutiveCount = 3
    
    fileprivate var randTextureHelper: Int?
    
    fileprivate let tileImages: [SKTexture] = [SKTexture(imageNamed: "tile1"), SKTexture(imageNamed: "tile2"),
                                               SKTexture(imageNamed: "tile3"), SKTexture(imageNamed: "tile4"),
                                               SKTexture(imageNamed: "tile5")]
    
    override func didMove(to view: SKView) {
        populateGameBoard()
        let allConsecutive = searchForConsecutive()
        animateConsecutives(allConsecutive) {
            self.detachFromGameBoard(listOfLists: allConsecutive)
            self.hideAndRemoveGameBoard {
                self.prepareLayoutForCoinsCount()
            }
        }
    }
}

//MARK: - GameBoard Population

extension ScratchScene {
    fileprivate func populateGameBoard() {
        for col in 0..<Int(boardSize.width) {
            for row in 0..<Int(boardSize.height) {
                
                let currentTexture = randTexture
                
                let currentSpriteNode = childNode(withName: "//i_\(col)x\(row)") as? SKSpriteNode
                currentSpriteNode?.texture = currentTexture
            }
        }
    }
    
    fileprivate var randTexture: SKTexture {
        
        var newIndex = 0
        if let lastRand = randTextureHelper {
            
            if arc4random_uniform(3) < 1 {
                newIndex = lastRand
            } else {
                newIndex = Int(arc4random_uniform(UInt32(tileImages.count)))
            }
            
        } else {
            newIndex = Int(arc4random_uniform(UInt32(tileImages.count)))
        }
        
        randTextureHelper = newIndex
        return tileImages[newIndex]
    }
}

//MARK: - Find Consecutive

extension ScratchScene {
    
    fileprivate func searchForConsecutive() -> [[SKSpriteNode]] {

        var allConsecutives: [[SKSpriteNode]] = []
        
        for row in 0..<Int(boardSize.height) {
            for col in 0..<Int(boardSize.width) - (desiredConsecutiveCount - 1) {
                
                var consecutives: [SKSpriteNode] = []
                
                var shouldCheckList = true
                for i in col..<col + desiredConsecutiveCount {
                    guard let node = childNode(withName: "//i_\(row)x\(i)") as? SKSpriteNode else {
                        shouldCheckList = false
                        break
                    }
                    consecutives.append(node)
                }
                if shouldCheckList {
                    if let parents = parentsOfTilesWithConsecutiveTextures(list: consecutives) {
                        allConsecutives.append(parents)
                        break
                    }
                }
            }
        }
        
        return allConsecutives
    }
    
    fileprivate func parentsOfTilesWithConsecutiveTextures(list: [SKSpriteNode]) -> [SKSpriteNode]? {
        
        guard let firstTexture = list.first?.texture else { return nil }
        
        for node in list {
            if node.texture != firstTexture { return nil }
        }
        
        var sameTextureParentsGroup: [SKSpriteNode] = []
        for node in list {
            guard let parent = node.parent as? SKSpriteNode else { return nil }
            sameTextureParentsGroup.append(parent)
        }
        
        return sameTextureParentsGroup
    }
}

//MARK: - Highlighting

extension ScratchScene {
    
    fileprivate func animateConsecutives(_ listOfLists: [[SKSpriteNode]], completion: @escaping (Void) -> Void) {
        
        var combinedActions: [SKAction] = [SKAction.wait(forDuration: 1.5)]
        
        for list in listOfLists {
            
            var perListActions: [SKAction] = []
            
            for node in list {
                let scaleAction = SKAction.run {
                    node.run(SKAction.sequence([SKAction.scale(to: 2.1, duration: 0.2),
                                                SKAction.wait(forDuration: 0.1),
                                                SKAction.colorize(with: .white, colorBlendFactor: 0, duration: 0.1),
                                                SKAction.scale(to: 1, duration: 0.2)]))
                }
                perListActions.append(scaleAction)
            }
            
            combinedActions.append(SKAction.run {
                self.sendSpritesToAlpha(1.0, list: [list])
                self.sendSpritesToAlpha(0.0, list: listOfLists.filter({ $0 != list }))
            })
            combinedActions.append(SKAction.group(perListActions))
            combinedActions.append(SKAction.wait(forDuration: 0.6))
        }
        combinedActions.append(SKAction.run(completion))
        run(SKAction.sequence(combinedActions))
    }
    
    fileprivate func sendSpritesToAlpha(_ alpha: CGFloat, list: [[SKSpriteNode]]) {
        for listLine in list {
            for node in listLine {
                node.zPosition = alpha
            }
        }
    }
}

//MARK: - Count Scores

extension ScratchScene {
    
    fileprivate func detachFromGameBoard(listOfLists: [[SKSpriteNode]]) {
        
        for i in 0..<listOfLists.count {
            let list = listOfLists[i]
            
            guard let positionOfContainer = list.first?.position else { break }
            
            let container = SKNode()
            container.position = positionOfContainer
            container.name = "detachedContainer_\(i)"
            addChild(container)
        
            for node in list {
                guard let parent = node.parent else { continue }
                let convertedCoord = container.convert(node.position, from: parent)
                node.removeFromParent()
                node.position = convertedCoord
                container.addChild(node)
            }
        }
    }
    
    fileprivate func hideAndRemoveGameBoard(withCompletion completion: @escaping (Void) -> Void) {
        guard let gameBoard = childNode(withName: "gameBoard") else {completion(); return }
        
        gameBoard.run(SKAction.sequence([SKAction.wait(forDuration: 2),
                                         SKAction.fadeOut(withDuration: 0.5),
                                         SKAction.run(completion),
                                         SKAction.run { gameBoard.removeFromParent() }]))
    }
    
    fileprivate func prepareLayoutForCoinsCount() {
        
        var allCointainers: [SKNode] = []
        
        var i = 0
        while childNode(withName: "detachedContainer_\(i)") != nil {
            guard let container = childNode(withName: "detachedContainer_\(i)") else { break }
            allCointainers.append(container)
            i += 1
        }
        
        let destinationCoords: [CGPoint] = [CGPoint(x: -300, y: 200),
                                            CGPoint(x: -300, y: 110),
                                            CGPoint(x: -300, y: 20),
                                            CGPoint(x: -300, y: -70),
                                            CGPoint(x: -300, y: -160)]
        var currentCoordHelper = 0
        
        for container in allCointainers {
            
            let currentCoord = destinationCoords[currentCoordHelper]
            container.run(SKAction.group([SKAction.move(to: currentCoord, duration: 1),
                                          SKAction.scale(to: 0.7, duration: 1),
                                          SKAction.run {
                                            let action = SKAction.colorize(with: .clear, colorBlendFactor: 0, duration: 1)
                                            for child in container.children { child.run(action)} }]))
            currentCoordHelper += 1
        }
    }
}
