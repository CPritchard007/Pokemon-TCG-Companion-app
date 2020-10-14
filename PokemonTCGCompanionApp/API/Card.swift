//  Card.swift
//  Pokemon_TCG_Companion_app
//
//  Created by Curtis Pritchard on 2020-09-30.
//

struct Card: Codable {
    let id: String? //POKEMON TCG UUID
    let name: String? // POKEMON NAME
    let hp: String?   // HEALTH POINTS
    let type: [String]? // ENERGY TYPE [FIRE TYPE, FIGHTING TYPE, ETC]
    let nationalPokedexNumber: Int? // THE NUMBER THAT POKEMON IS STORED IN THE POKEDEX

    let supertype: String? // ENERGY, TRAINER, POKEMON
    let subtype: String? // BASE, STAGE2, POKEMON TOOL, SPECIAL, RESTORED, ITEM, STADIUM, SUPPORT, GX, BREAK, EX, LEGEND, ROCKET SECRET MACHINE
    
    let imageUrl: String? // LOW RES IMAGE
    let imageUrlHiRes: String?  // HIGH RES IMAGE
    
    let rarity: String?  // THE RARITY OF SAID CARD
    let retreatCost: [String]?  // HOW MUCH ENERGY IT COSTS TO RETREAT
    let attacks: [Attack]?  // ATTACKS THAT YOUR POKEMON CAN DO
    let resistances: [Energy]? // WHAT ATTACKS ARE NOT SUPER EFFECTIVE
    let weaknesses: [Energy]? // WHAT IS SUPER EFFECTIVE AGAINST THIS POKEMON

}

struct Energy: Codable {
    let type: String
    let value: String
}

struct Attack: Codable {
    let cost: [String]?
    let name: String?
    let text: String?
    let damage: String?
}

