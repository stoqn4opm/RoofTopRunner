//
//  MainCharacterNodeJumpBehaviour.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import SpriteKit

class MainCharacterNodeJumpBehaviour: MainCharacterNodeEventDrivenBehaviour {
    
    static let eventName = Notification.Name("JumpEvent")
    static func makeEvent() {
        NotificationCenter.default.post(name: MainCharacterNodeJumpBehaviour.eventName, object: nil)
    }
    
    init(forMainCharacter character: MainCharacterNode) {
        super.init(withEventName: MainCharacterNodeJumpBehaviour.eventName, mainCharacterNode: character)
    }
    
    override func perform() {
        let colors: [UIColor] = [.yellow, .green, .blue, .magenta]
        let randIndex = arc4random_uniform(UInt32(colors.count))
        node?.color = colors[Int(randIndex)]
    }
}
