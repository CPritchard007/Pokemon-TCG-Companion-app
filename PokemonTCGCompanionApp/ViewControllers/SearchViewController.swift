//
//  SearchViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-15.
//

import UIKit


class SearchViewController: UIViewController {
  
    
    //MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    var cards = [
    Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                
    Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
        Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                    
        Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
        Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                    
        Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
        Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                    
        Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
        Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                    
        Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
            Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                        
            Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
            Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                        
            Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
            Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                        
            Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
        Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                    
        Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
            Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                        
            Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
            Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                        
            Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
            Card(id: "xy7-10", name: "Vespiquen", hp: "90", types: [.grass] , nationalPokedexNumber: 416, supertype: .pokemon, subtype: .stage1, imageUrl: "https://images.pokemontcg.io/xy7/10.png", imageUrlHiRes: "https://images.pokemontcg.io/xy7/10_hires.png", rarity: "Uncommon", retreatCost: nil, attacks: [Attack(cost: [.colorless], name: "Intelligence Gathering", text: "You may draw cards until you have 6 cards in your hand", damage: "10")], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
                        
            Card(id: "det1-17", name: "Ditto", hp: "60", types: [.colorless] , nationalPokedexNumber: 132, supertype: .pokemon, subtype: .basic, imageUrl: "https://images.pokemontcg.io/det1/17.png", imageUrlHiRes: "https://images.pokemontcg.io/det1/17_hires.png", rarity: "Rare Ultra", retreatCost: [.colorless], attacks: [Attack(cost: [.colorless], name: "Copy Anything", text: "Choose 1 of your opponent's Pokémon's attacks and use it as this attack. If this Pokémon doesn't have the necessary Energy to use that attack, this attack does nothing.", damage: nil)], resistances: nil, weaknesses: [Energy(type: .fire, value: "x2")]),
]

    
 
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        //TODO: add hidable UISearchController into the pages CollectionView with Scope bar [Pokemon, Energy, Trainer]
//        searchController.searchResultsUpdater = self
            
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ENTER CARD NAME"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    
}

extension SearchViewController: UICollectionViewDelegate {

}

extension SearchViewController: UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCardCell", for: indexPath) as! SearchCollectionCell
        
        let card = cards[indexPath.row]

        if let imageURL = card.imageUrl ,let url = URL(string: imageURL), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            cell.imgeView.image = image
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
    
}
