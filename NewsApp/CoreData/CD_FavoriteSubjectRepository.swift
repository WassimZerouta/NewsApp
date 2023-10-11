//
//  CD_FavoriteSubjectRepository.swift
//  NewsApp
//
//  Created by Wass on 15/04/2023.
//

import Foundation
import CoreData

final class CD_FavoriteSubjectRepository {
    
    // MARK: - Properties

    private let coreDataStack: CoreDataStackProtocol

    // MARK: - Init

    init(coreDataStack: CoreDataStackProtocol) {
      self.coreDataStack = coreDataStack
    }

    // MARK: - Repository

    func getFavoriteSubject(completion: ([CD_FavoriteSubject]) -> Void) {
        let request: NSFetchRequest<CD_FavoriteSubject> = CD_FavoriteSubject.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
          let favoriteSubject = try coreDataStack.viewContext.fetch(request)
          completion(favoriteSubject)
        } catch {
          completion([])
        }
    }

    func saveFavoriteSubject(name: String, isAdded: Bool, completion: () -> Void) -> CD_FavoriteSubject  {
        let favoriteSubject = CD_FavoriteSubject(context: coreDataStack.viewContext)
        favoriteSubject.name = name
        favoriteSubject.isAdded = isAdded
        do {
            try  coreDataStack.viewContext.save()
            completion()
        }
        catch {
            print("We are unable to save \(favoriteSubject.name ?? "the article")")
        }
        return favoriteSubject
    }
    
    func removeFavoriteSubject(favoriteSubject: CD_FavoriteSubject, completion: () -> Void) {
        coreDataStack.viewContext.delete(favoriteSubject)
        do {
            try  coreDataStack.viewContext.save()
            completion()
        }
        catch {
            print("We are unable to remove the article")
        }
    }
    
}
