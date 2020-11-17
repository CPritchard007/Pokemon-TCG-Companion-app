//
//  Deck+CoreDataProperties.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-11-17.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var card: Card?

}

extension Deck : Identifiable {

}