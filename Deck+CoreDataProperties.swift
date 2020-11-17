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

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var card: NSSet?

}

// MARK: Generated accessors for card
extension Deck {

    @objc(addCardObject:)
    @NSManaged public func addToCard(_ value: Card)

    @objc(removeCardObject:)
    @NSManaged public func removeFromCard(_ value: Card)

    @objc(addCard:)
    @NSManaged public func addToCard(_ values: NSSet)

    @objc(removeCard:)
    @NSManaged public func removeFromCard(_ values: NSSet)

}

extension Deck : Identifiable {

}
