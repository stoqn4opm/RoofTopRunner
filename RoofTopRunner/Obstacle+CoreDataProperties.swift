//
//  Obstacle+CoreDataProperties.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/18/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import CoreData


extension Obstacle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Obstacle> {
        return NSFetchRequest<Obstacle>(entityName: "Obstacle")
    }

    @NSManaged public var height: Int16
    @NSManaged public var texture: String?
    @NSManaged public var fromPage: ObstaclePage?

}
