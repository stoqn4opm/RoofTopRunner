//
//  EndlessLevelScene.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit
import SwiftyJSON

class EndlessLevelScene: SKScene {
    
    override func sceneDidLoad() {
        self.backgroundColor = .blue
        self.anchorPoint = .normalizedLowerLeft
        guard let model = loadLevelInfo() else { return }
        let obstaclePage = ObstaclePageNode(obstacleModel: model)
        self.addChild(obstaclePage)
        
        obstaclePage.run(SKAction.moveBy(x: -obstaclePage.length, y: 0, duration: 5))
    }
    
    func loadLevelInfo() -> JSON? {
        guard let filePath = Bundle.main.path(forResource: "page_model", ofType: "json") else {
            print("page_model.json not found")
            return nil
        }
        guard let jsonString = try? String.init(contentsOfFile: filePath, encoding: .utf8) else {
            print("can not load page_model.json file")
            return nil
        }
        guard let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        let json = JSON(data: dataFromString)
        return json
    }

}
