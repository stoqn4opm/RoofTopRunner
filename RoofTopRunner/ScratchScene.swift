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
    
    fileprivate let coinsForTextures : [Int] = [500, 1000, 1500, 2000, 2500]
    
    override func didMove(to view: SKView) {
        populateGameBoard()
        let allConsecutive = searchForConsecutive()
        
        if allConsecutive.isEmpty {
            hideAndRemoveGameBoard {
                self.presentNoPriceEnding {
                    self.restartGame()
                }
            }
        } else {
            animateConsecutives(allConsecutive) {
                self.detachFromGameBoard(listOfLists: allConsecutive)
                self.hideAndRemoveGameBoard {
                    self.prepareLayoutForCoinsCount() {
                        self.countDownCoins() {
                            self.restartGame()
                        }
                    }
                }
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
    
    fileprivate func prepareLayoutForCoinsCount(completion: @escaping (Void) -> Void) {
        
        var allContainers: [SKNode] = []
        
        var i = 0
        while childNode(withName: "detachedContainer_\(i)") != nil {
            guard let container = childNode(withName: "detachedContainer_\(i)") else { break }
            allContainers.append(container)
            i += 1
        }
        
        moveConsecutiveItemsToCountingLocation(allContainers: allContainers) {
            self.placeLabelsForCountingPointsNextTo(allContainers, completion: completion)
        }
        
    }
    
    fileprivate func moveConsecutiveItemsToCountingLocation(allContainers: [SKNode], completion: @escaping (Void) -> Void) {
        
        let destinationCoords: [CGPoint] = [CGPoint(x: -300, y: 230),
                                            CGPoint(x: -300, y: 140),
                                            CGPoint(x: -300, y: 50),
                                            CGPoint(x: -300, y: -40),
                                            CGPoint(x: -300, y: -130)]
        var currentCoordHelper = 0
        
        for container in allContainers {
            
            let currentCoord = destinationCoords[currentCoordHelper]
            var action = SKAction.group([SKAction.move(to: currentCoord, duration: 1),
                                         SKAction.scale(to: 0.7, duration: 1),
                                         SKAction.run {
                                            let action = SKAction.colorize(with: .clear, colorBlendFactor: 0, duration: 1)
                                            for child in container.children { child.run(action)} }])
            
            if container == allContainers.first { action = SKAction.sequence([action, SKAction.run(completion)]) }
            container.run(action)
            currentCoordHelper += 1
        }
    }
    
    fileprivate func placeLabelsForCountingPointsNextTo(_ containers: [SKNode], completion: @escaping (Void) -> Void) {
        
        guard let lastContainerPosition = containers.last else { return }
        let positionForTotalLabel = CGPoint(x: -lastContainerPosition.position.x + 250, y: lastContainerPosition.position.y - 100)
        var combinedAction: [SKAction] = [SKAction.run(SKAction.move(to: positionForTotalLabel, duration: 0.01), onChildWithName: "totalCoinsContainer"),
                                          SKAction.run(SKAction.fadeIn(withDuration: 1), onChildWithName: "totalCoinsContainer"),
                                          SKAction.wait(forDuration: 1.5)]
        
        for container in containers {
            let labelPosition = CGPoint(x: -container.position.x + 200, y: container.position.y - 25)
            let label = SKLabelNode(fontNamed: "PressStart2P")
            label.position = labelPosition
            label.horizontalAlignmentMode = .right
            label.verticalAlignmentMode = .top
            
            label.fontSize = 40
            label.name = "labelFor\(container.name ?? "")"
            label.alpha = 0
            addChild(label)
            
            let appearGroup = SKAction.run {
                let action = SKAction.group([SKAction.moveTo(x: -container.position.x + 250, duration: 0.3), SKAction.fadeIn(withDuration: 0.3)])
                label.run(action)
            
                let newlyAddedScores = self.scoresForContainer(container)
                label.text = "\(newlyAddedScores)"
                
                let totalCount = self.childNode(withName: "//totalCoinsLabel") as? SKLabelNode
                if let totalCountText = totalCount?.text {
                    
                    let scoresUntilNow = Int(totalCountText) ?? 0
                    totalCount?.text = "\(scoresUntilNow + newlyAddedScores)"
                    
                    SoundManager.shared.playSoundEffectNamed("sfx_coin_obtained")
                }
            }
            
            combinedAction.append(appearGroup)
            combinedAction.append(SKAction.wait(forDuration: 1.5))
        }
        combinedAction.append(SKAction.run(completion))
        containers.first?.parent?.run(SKAction.sequence(combinedAction))
    }
    
    fileprivate func scoresForContainer(_ container: SKNode) -> Int {
        let textureSprite = container.childNode(withName: ".//i_*") as? SKSpriteNode
        guard let texture = textureSprite?.texture else { return 0 }
        guard let indexOfTexture = tileImages.index(of: texture) else { return 0 }
        return coinsForTextures[indexOfTexture]
    }
}

//MARK: - Coins Countdown

extension ScratchScene {
    
    fileprivate func countDownCoins(completion: @escaping (Void) -> Void) {
    
        SoundManager.shared.playSoundEffectNamed("sfx_coin_countdown", loop: true)
        
        guard let totalCountLabel = childNode(withName: "//totalCoinsLabel") as? SKLabelNode else { return }
        guard let totalCountText = totalCountLabel.text else { return }
        guard var coins = Int(totalCountText) else { return }

        totalCountLabel.run(SKAction.sequence([
            SKAction.repeat(SKAction.sequence([SKAction.run { totalCountLabel.text = "\(coins)"; coins -= 1 },
                                               SKAction.wait(forDuration: 0.001)]), count: coins + 1),
            SKAction.run {
                SoundManager.shared.stopSoundEffect()
            }, SKAction.run(completion)]))
    }
}

//MARK: - Dismiss/Restart

extension ScratchScene {
    
    fileprivate func restartGame() {
        let fadeOutGlobalAction = SKAction.run {
            
            for child in self.children {
                guard let childName = child.name else { continue }
                if childName.contains("detachedContainer_") || childName == "totalCoinsContainer" || childName == "badEndingLabel" {
                    child.run(SKAction.fadeOut(withDuration: 1))
                }
            }
        }
        
        run(SKAction.sequence([SKAction.wait(forDuration: 3),
                               fadeOutGlobalAction,
                               SKAction.wait(forDuration: 3),
                               SKAction.run { GameManager.shared.loadScratchScene() }]))
    }
}

//MARK: - No Price Ending

extension ScratchScene {
    fileprivate func presentNoPriceEnding(withCompletion completion: @escaping (Void) -> Void) {
        
        let badEndingLabel = childNode(withName: "badEndingLabel") as? SKLabelNode
        badEndingLabel?.text = "NO PRICE".localized
        badEndingLabel?.run(SKAction.sequence([SKAction.fadeIn(withDuration: 1),
                                               SKAction.wait(forDuration: 11), // wait for sfx_no_price to finish
                                               SKAction.run(completion)]))
        
        SoundManager.shared.playSoundEffectNamed("sfx_no_price")
        if badEndingLabel == nil {
            completion()
        }
    }
}
