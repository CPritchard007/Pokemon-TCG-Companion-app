//
//  CoreDataStack.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-11-11.
//

import Foundation
import CoreData

class CoreDataStack{
    private let modelName: String
    
    init(modelName: String){
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        
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
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Unresolved error trying to save the context: \(error) : \(error.localizedDescription)")
        }
    }
    
}
