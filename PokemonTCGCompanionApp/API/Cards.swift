//
//  Cards.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-13.
//

import UIKit

struct Cards: Codable {
    var cardList = [
        
        Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                    
        Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")])
    ]

}
