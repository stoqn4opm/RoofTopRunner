//
//  ObstaclePage+CoreDataProperties.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/18/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import CoreData


extension ObstaclePage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObstaclePage> {
        return NSFetchRequest<ObstaclePage>(entityName: "ObstaclePage")
    }

    @NSManaged public var obstacles: NSSet?

}

// MARK: Generated accessors for obstacles
extension ObstaclePage {

    @objc(addObstaclesObject:)
    @NSManaged public func addToObstacles(_ value: Obstacle)

    @objc(removeObstaclesObject:)
    @NSManaged public func removeFromObstacles(_ value: Obstacle)

    @objc(addObstacles:)
    @NSManaged public func addToObstacles(_ values: NSSet)

    @objc(removeObstacles:)
    @NSManaged public func removeFromObstacles(_ values: NSSet)

}
