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
    var isTournamentLocked: Bool = true
    var coreDataStack: CoreDataStack!

    //MARK: - Outlets
    @IBOutlet weak var deckCountLabel: UILabel!
    @IBOutlet weak var tournamentLock: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        cards = Array(cardSet)
        var quantityCount = 0
        for item in cards {
            quantityCount += Int(item.quantity)
        }
        deckCountLabel.text = "\(quantityCount)/60"
        tableView.reloadData()
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
            print(cards.filter {$0.superType == "Pokémon" }.count)
            return cards.filter {$0.superType == "Pokémon" }.count
        case 1:
            print(cards.filter {$0.superType == "Trainer" }.count)
            return cards.filter {$0.superType == "Trainer" }.count
        case 2:
            print(cards.filter {$0.superType == "Energy" }.count)
            return cards.filter {$0.superType == "Energy" }.count
           
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DeckListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DeckListCell
        
        let pokemon = cards.filter {$0.superType == "Pokémon"}
        print("POKEMON: \(pokemon)")
        let trainers = cards.filter {$0.superType == "Trainer"}
        print("TRAINER: \(trainers)")
        let energy = cards.filter {$0.superType == "Energy"}
        print("ENERGY: \(energy)")
        
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
            
            let item = trainers[indexPath.row]
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckListCell", for: indexPath) as? DeckListCell
        
        
        let add = UIContextualAction(style: .normal, title: "+") { (UIContextualAction, UIView, nil) in
            print("----\(indexPath.section):\(indexPath.row) => \(cell?.idLabel.text)")
        }
        
        add.backgroundColor = UIColor(named: "secondaryColor")
        add.image = UIImage(systemName: "plus")
        
    
        let remove = UIContextualAction(style: .normal, title: "-") { (UIContextualAction, UIView, nil) in

        }
        
        remove.backgroundColor = UIColor(named: "secondaryColor")
        remove.image = UIImage(systemName: "minus")
        
        let configuration = UISwipeActionsConfiguration(actions: [add, remove])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}

extension DeckListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "secondaryColor")
        let headerView = view as! UITableViewHeaderFooterView
            headerView.textLabel?.textColor = UIColor.white
        
    }

}

