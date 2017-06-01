//
//  MainCharacterNodeBehaviour.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import SpriteKit

protocol MainCharacterNodeBehaviour {
    weak var node: MainCharacterNode? { get }
    func perform()
    func stopPerforming()
}
