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
    @NSManaged public var type: [String]?
    @NSManaged public var imageURL: String?
    @NSManaged public var rarity: String?
    @NSManaged public var text: [String]?
    @NSManaged public var quantity: Int32
    @NSManaged public var decks: NSSet?

}

// MARK: Generated accessors for decks
extension Card {

    @objc(addDecksObject:)
    @NSManaged public func addToDecks(_ value: Deck)

    @objc(removeDecksObject:)
    @NSManaged public func removeFromDecks(_ value: Deck)

    @objc(addDecks:)
    @NSManaged public func addToDecks(_ values: NSSet)

    @objc(removeDecks:)
    @NSManaged public func removeFromDecks(_ values: NSSet)

}

extension Card : Identifiable {

}
