//
//  CoreDataStack.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-11-11.
//

import Foundation
import CoreData

class CoreDataStack{
    // this will be entered for every class the coreData store is used
    private let modelName: String
    
    init(modelName: String){
        self.modelName = modelName
    }
    
    // due to the container taking allot to get going, dont run it until it is necessary
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        
        // create a new container with the same modelname as we stated above
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
    
            if let error = error {
                fatalError("Unresolved error creating persistent store : \(error): \(error.localizedDescription)")
            }
        })
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    // once the user calls saveContext, the application will save the new content, and add it to the sql database.
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Unresolved error trying to save the context: \(error) : \(error.localizedDescription)")
        }
    }
    
}
