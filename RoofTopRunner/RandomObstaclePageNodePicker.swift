//
//  RandomObstaclePageNodePicker.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class RandomObstaclePageNodePicker {
    
    func next() {
        
    }
}

extension RandomObstaclePageNodePicker {
    
    func randomObstaclePageNode(forDifficulty difficulty: Int) {
//        let model = chooseObstaclePageModelWithDifficulty(difficulty)
//        let obstaclePage = ObstaclePageNode(obstacleModel: model)
    }
    
    func chooseObstaclePageModelWithDifficulty(_ difficulty: Int) -> JSON? {
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
    
    func randomObstaclePageModel(forDifficulty difficulty: Int) {
        let resourcesPath = Bundle.main.paths(forResourcesOfType: "json", inDirectory: "obstacle_models")
        
        for filePath in resourcesPath {
            guard let jsonString = try? String.init(contentsOfFile: filePath, encoding: .utf8) else {
                print("can not load \"\(filePath)\" file")
                return
            }
            guard let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) else {
                return
            }
            let json = JSON(data: dataFromString)
        }
    }
}
