//
//  DataStore.swift
//  2for1
//
//  Created by Douglas Galante on 1/6/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    static let sharedInstance = DataStore()
    private init () {}
    
    var players: [Player] = []
    
    func fetchData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PlayerData>(entityName: "PlayerData")
        
        do{
            let playerData = try context.fetch(fetchRequest)
            
            //creat players from PlayerData
            for player in playerData {
                let convertedPlayer = Player(tag: player.tag!, firstName: player.firstName!, lastName: player.lastName!)
                players.append(convertedPlayer)
            }
            
        } catch {
            print("catch players fetch request")
        }
    }
    
    func save(_ player: Player) {
        let context = persistentContainer.viewContext
        let entity = PlayerData(context: context)
        entity.firstName = player.firstName
        entity.lastName = player.lastName
        entity.tag = player.tag
        saveContext()
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
