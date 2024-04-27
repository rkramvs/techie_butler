//
//  CoreDataHelper.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import CoreData

class CoreDataHelper: ObservableObject {
    
    public static var shared = CoreDataHelper()
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer = NSPersistentContainer(name: "techie_butler")
    
    var mainContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    var bgContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    @Published var isPersistentStoreGetLoaded: Bool = false

 
    func loadContainer(completion: @escaping (Error?) -> ()) {
        
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         
        */
        
        
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            completion(error)
//            print(storeDescription.url)
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                self.mainContext.reset()
                self.isPersistentStoreGetLoaded = true
            }
        })
    }
    
    // MARK: - Core Data Saving support

    @discardableResult
    func saveContext() -> Error? {
        
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
                return nil
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return nil
    }
    
    
    func deleteALL(completion: @escaping (Error?) -> ()) {
        
        CoreDataHelper.shared.saveContext()
        // Get a reference to a NSPersistentStoreCoordinator
        let storeContainer =
            persistentContainer.persistentStoreCoordinator

        do {
            // Delete each existing persistent store
            for store in storeContainer.persistentStores {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            }
            
            isPersistentStoreGetLoaded = false
            
        }catch {
            completion(error)
            return
        }
       
        loadContainer(completion: completion)

    }
}

