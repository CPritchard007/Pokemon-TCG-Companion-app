//
//  Card+CoreDataProperties.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-11-17.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var hp: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nationalPokedexNumber: Int32
    @NSManaged public var subType: String?
    @NSManaged public var superType: String?
    @NSManaged public var type: String?
    @NSManaged public var deck: NSSet?

}

// MARK: Generated accessors for deck
extension Card {

    @objc(addDeckObject:)
    @NSManaged public func addToDeck(_ value: Deck)

    @objc(removeDeckObject:)
    @NSManaged public func removeFromDeck(_ value: Deck)

    @objc(addDeck:)
    @NSManaged public func addToDeck(_ values: NSSet)

    @objc(removeDeck:)
    @NSManaged public func removeFromDeck(_ values: NSSet)

}

extension Card : Identifiable {

}
