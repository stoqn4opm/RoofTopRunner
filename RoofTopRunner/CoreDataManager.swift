//
//  CoreDataManager.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/16/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    //MARK: - Names & Paths
    
    private static let databaseModelFileName = "RoofTopRunnerModel"
    private static let databaseModelExtension = "momd"

    private static let databaseFolderName = "Database"
    private static let databaseName = "RoofTopRunner"
    private static let databaseExtension = "sqlite"
    
    //MARK: - Singleton Reference
    
    public static let shared: CoreDataManager = {
        let instance = CoreDataManager()
        return instance
    }()
    
    //MARK: - Object's Lifecycle
    
    private override init(){
        super.init()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(mainContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: _mainContext)
        notificationCenter.addObserver(self, selector: #selector(privateContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: _privateContext)
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    //MARK: - Private Properties
    
    fileprivate lazy var _mainContext: NSManagedObjectContext = {
        let result = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        result.persistentStoreCoordinator = self.cordinator
        result.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return result
    }()
    
    fileprivate lazy var _privateContext: NSManagedObjectContext = {
        let result = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        result.persistentStoreCoordinator = self.cordinator
        result.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return result
    } ()

    fileprivate var model: NSManagedObjectModel? {
        if let modelURL = Bundle.main.url(forResource: "RoofTopRunnerModel", withExtension: "momd") {
            let result = NSManagedObjectModel(contentsOf: modelURL);
            return result
        }
        return nil
    }
    
    fileprivate lazy var databaseURL: URL? = {
        let fileManager = FileManager.default
        var databaseURL = fileManager.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
        databaseURL = databaseURL.appendingPathComponent(CoreDataManager.databaseFolderName, isDirectory: true)
        if fileManager.fileExists(atPath: databaseURL.path) == false{
            do{
                try fileManager.createDirectory(at: databaseURL, withIntermediateDirectories: true, attributes: nil)
            }
            catch{
                return nil
            }
        }
        databaseURL = databaseURL.appendingPathComponent(CoreDataManager.databaseName)
        databaseURL = databaseURL.appendingPathExtension(CoreDataManager.databaseExtension)
        return databaseURL
    }()
    
    fileprivate lazy var cordinator: NSPersistentStoreCoordinator? = {
        
        if let model = self.model {
            let result = NSPersistentStoreCoordinator(managedObjectModel: model)
            let databaseURL = self.databaseURL
            let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
            do{
                try result.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: databaseURL, options: options)
                return result
            }
            catch{
                print("Ops there was an error \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }()
}

//MARK: - Contexts (Public Interface)

extension CoreDataManager {
    
    public var mainContext: NSManagedObjectContext { return _mainContext }
    public var privateContext: NSManagedObjectContext { return _privateContext }
    
    public func saveContext(_ context: NSManagedObjectContext) throws{
        try context.save()
    }
}

//MARK: - Merge Changes Between Contexts

extension CoreDataManager {
    
    @objc fileprivate func privateContextDidSave(notification : Notification) {
        _mainContext.perform {
            self._mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }

    @objc fileprivate func mainContextDidSave(notification : Notification) {
        _privateContext.perform {
            self._privateContext.mergeChanges(fromContextDidSave: notification)
        }
    }
}
