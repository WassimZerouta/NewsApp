//
//  CoreDataStack.swift
//  NewsApp
//
//  Created by Wass on 13/04/2023.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    
    var viewContext: NSManagedObjectContext {
      return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "CoreDataModel")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
}
