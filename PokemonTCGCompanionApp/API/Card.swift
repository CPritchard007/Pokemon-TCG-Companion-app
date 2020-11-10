//  Card.swift
//  Pokemon_TCG_Companion_app
//
//  Created by Curtis Pritchard on 2020-09-30.
//
enum SuperType: String, Codable, CaseIterable {
    case pokemon = "Pokémon"
    case trainer = "Trainer"
    case energy = "Energy"
}

enum SubType: String, Codable {
        case stadium = "Stadium"
        case mega = "MEGA"
        case v = "V"
        case item = "Item"
        case stage2 = "Stage 2"
        case levelUp = "Level Up"
        case Break = "BREAK"
        case stage1 = "Stage 1"
        case vMax = "VMAX"
        case rocketsSecretMachine = "Rocket's Secret Machine"
        case basic = "Basic"
        case pokemonTool = "Pokémon Tool"
        case technicalMachine = "Technical Machine"
        case ex = "EX"
        case legend = "LEGEND"
        case special = "Special"
        case tagTeam = "TAG TEAM"
        case gx = "GX"
        case supporter = "Supporter"
        case restored = "Restored"
}

enum Type: String, Codable {
    case colorless = "Colorless"
    case darkness = "Darkness"
    case dragon = "Dragon"
    case fairy = "Fairy"
    case fighting = "Fighting"
    case fire = "Fire"
    case grass = "Grass"
    case lightning = "Lightning"
    case metal = "Metal"
    case psychic = "Psychic"
    case water = "Water"
}
struct Card: Codable {
    //MARK: - Search INFO
    let id: String //POKEMON TCG ID
    let name: String // POKEMON NAME
    let supertype: SuperType // ENERGY, TRAINER, POKEMON
    
    //MARK: -  Display Image
    let imageUrl: String? // LOW RES IMAGE
    let imageUrlHiRes: String?  // HIGH RES IMAGE
    
    //MARK: - Detailed List Info
    let nationalPokedexNumber: Int? // THE NUMBER THAT POKEMON IS STORED IN THE POKEDEX
    let hp: String?   // HEALTH POINTS
    let types: [Type]? // ENERGY TYPE [FIRE TYPE, FIGHTING TYPE, ETC]

    
    // let subtype: SubType? // BASE, STAGE2, POKEMON TOOL, SPECIAL, RESTORED, ITEM, STADIUM, SUPPORT, GX, BREAK, EX, LEGEND, ROCKET SECRET MACHINE
    
    
    let rarity: String?  // THE RARITY OF SAID CARD
    let retreatCost: [Type]?  // HOW MUCH ENERGY IT COSTS TO RETREAT
    let attacks: [Attack]?  // ATTACKS THAT YOUR POKEMON CAN DO
    let ability: Ability?
    let resistances: [Energy]? // WHAT ATTACKS ARE NOT SUPER EFFECTIVE
    let weaknesses: [Energy]? // WHAT IS SUPER EFFECTIVE AGAINST THIS POKEMON
    
    let text: [String]? // only used on trainers

}

struct Energy: Codable {
    let type: Type
    let value: String
}

struct Attack: Codable {
    let cost: [Type.RawValue]?
    let name: String?
    let text: String?
    let damage: String?
}

struct Ability: Codable {
    let name: String
    let text: String?
    let type: String
}

struct Cards: Codable {
    var cards: [Card]
}
