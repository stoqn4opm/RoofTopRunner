//
//  MainCharacterNodeEventDrivenBehaviour.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 6/1/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation

class MainCharacterNodeEventDrivenBehaviour: MainCharacterNodeBehaviour {
    
    let eventStartName: NSNotification.Name
    let eventEndName: NSNotification.Name
    weak var node: MainCharacterNode?
    
    init(withEventStartName eventStartName: NSNotification.Name, eventEndName: NSNotification.Name, mainCharacterNode: MainCharacterNode) {
        self.eventStartName = eventStartName
        self.eventEndName = eventEndName
        self.node = mainCharacterNode
        NotificationCenter.default.addObserver(self, selector: #selector(handleEventStart), name: self.eventStartName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEventEnd), name: self.eventEndName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: eventStartName, object: nil)
        NotificationCenter.default.removeObserver(self, name: eventEndName, object: nil)
    }
    
    @objc private func handleEventStart() {
        perform()
    }
    
    @objc private func handleEventEnd() {
        stopPerforming()
    }
    
    func perform() { } // to be overwritten in childs
    func stopPerforming() { } // to be overwritten in childs
}

