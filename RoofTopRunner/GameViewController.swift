//
//  GameViewController.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/15/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = GameManager.shared.skView
        GameManager.shared.loadEndlessLevelScene()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
