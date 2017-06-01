//
//  MainCharacterNodeEventDrivenBehaviour.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation

class MainCharacterNodeEventDrivenBehaviour: MainCharacterNodeBehaviour {
    
    let eventName: NSNotification.Name
    weak var node: MainCharacterNode?
    
    init(withEventName eventName: NSNotification.Name, mainCharacterNode: MainCharacterNode) {
        self.eventName = eventName
        self.node = mainCharacterNode
        NotificationCenter.default.addObserver(self, selector: #selector(handleEvent), name: self.eventName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: eventName, object: nil)
    }
    
    @objc private func handleEvent() {
        perform()
    }
    
    func perform() { } // to be overwritten in childs
    func stopPerforming() { } // to be overwritten in childs
}

