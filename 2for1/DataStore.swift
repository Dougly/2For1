//
//  DataStore.swift
//  2for1
//
//  Created by Douglas Galante on 1/6/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class DataStore {
    
    static let sharedInstance = DataStore()
    var players: [Player] = []

    
    private init () {}
    
    
    func fetchData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Player>(entityName: "Player")
        do {
            players = try context.fetch(fetchRequest)
        } catch {
            print("catch players fetch request")
        }
    }
    
    func savePlayer(_ firstName: String, lastName: String, tag: String, file: String) {
        let context = persistentContainer.viewContext
        let entity = Player(context: context)
        entity.firstName = firstName
        entity.lastName = lastName
        entity.tag = tag
        entity.file = file
        saveContext()
        players.append(entity)
        players.sort { (p1, p2) -> Bool in
            return p1.tag! > p2.tag!
        }
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "_for1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
