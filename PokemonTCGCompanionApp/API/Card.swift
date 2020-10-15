//  Card.swift
//  Pokemon_TCG_Companion_app
//
//  Created by Curtis Pritchard on 2020-09-30.
//
enum SuperType: String, Codable {
    case pokemon = "Pokémon"
    case trainer = "Trainer"
    case energy = "Energy"
}

enum SubType: String, Codable {
    case basic =  "Basic"
    case stage1 = "Stage 1"
    case stage2 = "stage 2"
    case pokemonTool = "Pokémon Tool"
    case special = "Special"
    case restored = "Restored"
    case item = "Item"
    case stadium = "Stadium"
    case support = "Support"
    case gx = "GX"
    case Break = "break"
    case ex = "EX"
    case legend = "Legend"
    case rocketsSecretMachine = "Rocket`s Secret Machine"
}

enum Type: String, Codable {
    case grass = "Grass"
    case fire = "Fire"
    case lightning = "Lightning"
    case darkness = "Darknesss"
    case fighting = "Fighting"
    case fairy = "fairy"
    case colorless = "colorless"
    case dragon = "Dragon"
    case psychic = "Psychic"
    case metal = "Metal"
    case water = "Water"
}
struct Card: Codable {
    //MARK: - Search INFO
    let id: String //POKEMON TCG ID
    let name: String // POKEMON NAME
    let supertype: SuperType? // ENERGY, TRAINER, POKEMON
    
    //MARK: -  Display Image
    let imageUrl: String? // LOW RES IMAGE
    let imageUrlHiRes: String?  // HIGH RES IMAGE
    
    //MARK: - Detailed List Info
    let nationalPokedexNumber: Int? // THE NUMBER THAT POKEMON IS STORED IN THE POKEDEX
    let hp: String?   // HEALTH POINTS
    let types: [Type]? // ENERGY TYPE [FIRE TYPE, FIGHTING TYPE, ETC]
    let subtype: SubType? // BASE, STAGE2, POKEMON TOOL, SPECIAL, RESTORED, ITEM, STADIUM, SUPPORT, GX, BREAK, EX, LEGEND, ROCKET SECRET MACHINE
    let rarity: String?  // THE RARITY OF SAID CARD
    let retreatCost: [Type]?  // HOW MUCH ENERGY IT COSTS TO RETREAT
    let attacks: [Attack]?  // ATTACKS THAT YOUR POKEMON CAN DO
    let resistances: [Energy]? // WHAT ATTACKS ARE NOT SUPER EFFECTIVE
    let weaknesses: [Energy]? // WHAT IS SUPER EFFECTIVE AGAINST THIS POKEMON

}

struct Energy: Codable {
    let type: Type
    let value: String
}

struct Attack: Codable {
    let cost: [Type]?
    let name: String?
    let text: String?
    let damage: String?
}

