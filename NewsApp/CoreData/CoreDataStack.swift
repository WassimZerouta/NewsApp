//
//  CoreDataStack.swift
//  NewsApp
//
//  Created by Wass on 13/04/2023.
//

import Foundation
import CoreData


protocol CoreDataStackProtocol {
    var viewContext: NSManagedObjectContext { get }
    var persistentContainer: NSPersistentContainer { get }
}

final class CoreDataStack: CoreDataStackProtocol {
    
    static let shared = CoreDataStack()
    private let containerName = "CoreDataModel"
    
    var viewContext: NSManagedObjectContext {
      return CoreDataStack.shared.persistentContainer.viewContext
    }
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: containerName)
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
}

final class TestCoreDataStack: CoreDataStackProtocol {
    
    private let containerName = "CoreDataModel"

    static let shared = TestCoreDataStack()
    
    var viewContext: NSManagedObjectContext {
        return TestCoreDataStack.shared.persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: containerName)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
