//
//  DeckListController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-11-10.
//

import UIKit
import CoreData

class DeckListController: UIViewController {
    
    //MARK: - Variables
    var deck: Deck!
    var cards = [Card]()
    var localCardSet: Set<Card>!
    var isTournamentLocked: Bool!
    var coreDataStack: CoreDataStack!
    var pokemon = [Card]()
    var trainer = [Card]()
    var energy = [Card]()

    //MARK: - Outlets
    @IBOutlet weak var deckCountLabel: UILabel!
    @IBOutlet weak var tournamentLock: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTournamentLocked = deck.tournamentLocked
        
        tableView.dataSource = self
        tableView.delegate = self
        // remove once you can jump to display
        tableView.allowsSelection = false
        
        if isTournamentLocked {
            tournamentLock.image = UIImage(systemName: "lock.fill")
        } else {
            tournamentLock.image = UIImage(systemName: "lock.open.fill")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        guard let cardSet = deck.cards as? Set<Card> else { return }
        localCardSet = cardSet
        cards = Array(cardSet)
        
        pokemonReshuffle()
        quantityCardCount()
        
        tableView.reloadData()
    }
    
    func pokemonReshuffle () {
        pokemon = cards.filter {$0.superType == "Pokémon"}
        trainer = cards.filter {$0.superType == "Trainer"}
        energy = cards.filter {$0.superType == "Energy"}
    }
    func quantityCardCount() {
        var quantityCount = 0
        for item in cards {
            quantityCount += Int(item.quantity)
        }
        deckCountLabel.text = "\(quantityCount)/60"
        if quantityCount > 60 , isTournamentLocked == true {
            deckCountLabel.textColor = .red
            let ac = UIAlertController(title: "Do you want to turn off Tournament Lock?", message: "A standard card game is locked to a total of 60 cards. Do you Want to turn the warnings off?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Turn Off", style: .default, handler: {_ in self.isTournamentLocked = false}))
            ac.addAction(UIAlertAction(title: "Keep On", style: .default, handler: nil))
            
            present(ac, animated: true, completion: nil)
            
        }
        
    }
    
}

extension DeckListController: UITableViewDataSource {
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "POKÈMON"
        case 1:
            return "TRAINER"
        case 2:
            return "ENERGY"
        default:
            return "unknown"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return pokemon.count
        case 1:
            return trainer.count
        case 2:
            return energy.count
           
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DeckListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DeckListCell
        
        
        if indexPath.section == 0 {
            
            let item = pokemon[indexPath.row]
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.id
            cell.quantityLabel.text = "x\(item.quantity)"
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.systemGray5
            }
            
            return cell
        } else if indexPath.section == 1 {
            
            let item = trainer[indexPath.row]
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.id
            cell.quantityLabel.text = "x\(item.quantity)"
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.systemGray5
            }
            
            return cell
        } else {
            
            let item = energy[indexPath.row]
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.id
            cell.quantityLabel.text = "x\(item.quantity)"
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.systemGray5
            }
            
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var currentCard: Card?
        
        switch indexPath.section {
        case 0:
            currentCard = pokemon[indexPath.row]
        case 1:
            currentCard = trainer[indexPath.row]
        case 2:
            currentCard = energy[indexPath.row]
        default:
            currentCard = nil
        }
        
        guard let card = currentCard else { return nil }
        
        let add = UIContextualAction(style: .normal, title: "+") { (UIContextualAction, UIView, completion) in
            card.quantity += 1
            tableView.reloadRows(at: [indexPath], with: .none)
            self.quantityCardCount()
            completion(true)
        }
        add.backgroundColor = UIColor(named: "primaryColor")
        add.image = UIImage(systemName: "plus")
        
    
        let remove = UIContextualAction(style: .normal, title: "-") { (UIContextualAction, UIView, completion) in
    
            if card.quantity == 1 {
                let ac = UIAlertController(title: "are you sure?", message: "by removing this, the card will no longer be stored localy, and will have to be re-added", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
                    self.deck.removeFromCards(card)
                    
                    self.cards.removeAll(where: {
                        return $0.id == card.id
                    })
                    self.pokemonReshuffle()
                    self.quantityCardCount()
                    tableView.reloadData()
                    
                }))
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(ac, animated: true, completion: nil)
            } else {
                card.quantity -= 1
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            self.quantityCardCount()

            
            completion(true)

        }
        remove.backgroundColor = UIColor(named: "secondaryColor")
        remove.image = UIImage(systemName: "minus")
        
        
        let configuration = UISwipeActionsConfiguration(actions: [add, remove])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.coreDataStack.saveContext()
    }
    
}

extension DeckListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "secondaryColor")
        let headerView = view as! UITableViewHeaderFooterView
            headerView.textLabel?.textColor = UIColor.white
        
    }

}

