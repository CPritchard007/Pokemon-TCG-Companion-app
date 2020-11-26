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
    
    
    
    //MARK: - functions
    
    
    
        //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get whether the deck has tournament lock on
        isTournamentLocked = deck.tournamentLocked
        
        tableView.dataSource = self
        tableView.delegate = self
        // remove once you can jump to display
        tableView.allowsSelection = false
        
       

    }
    
        //MARK:  ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        guard let cardSet = deck.cards as? Set<Card> else { return }
        localCardSet = cardSet
        cards = Array(cardSet)
        
        // sort all cards into there seperate types (pokemon, trainers, energy)
        pokemonReshuffle()
        
        // set the count at the top of the application page.
        // NOTE: The quantity count will return a value that has no use for me at this position, so I silence it by adding it to _
        _ = quantityCardCount()
        
        // set the lock at the top wether the deck is in tournament mode or not
        setLockType()
    
        tableView.reloadData()
    }
    
        //MARK: pokemonReshuffle
    func pokemonReshuffle () {
        // get whether the card is of subtype pokemon, trainer, or energy
        pokemon = cards.filter {$0.superType == "Pokémon"}
        trainer = cards.filter {$0.superType == "Trainer"}
        energy = cards.filter {$0.superType == "Energy"}
    }
        //MARK: quantityCount
    func quantityCardCount() -> Bool{
        // set a default value of quantity count
        var quantityCount = 0
        for item in cards {
            // for each card, add the quantity to quantityCount
            quantityCount += Int(item.quantity)
        }
        // set the quantity count out of 60 (noted as the total cards allowed in a standard deck)
        deckCountLabel.text = "\(quantityCount)/60"
    
        // if the card count is over the max
        if quantityCount > 60 , isTournamentLocked == true {
            // set the color of the text to red
            self.deckCountLabel.tintColor = .red
            // set an alert that will warn the user that they are now above the total number of cards that is allowed in a standard pokemon tournament.
            let ac = UIAlertController(title: "Do you want to turn off Tournament Lock?", message: "A standard card game is locked to a total of 60 cards. Do you Want to turn the warnings off?", preferredStyle: .alert)
            // if the user clicks on the "Turn Off" button, then the application will allow the user to add as many cards as they want, and the application will not warn them anymore
            ac.addAction(UIAlertAction(title: "Turn Off", style: .default, handler: {_ in
                self.isTournamentLocked = false
                self.deck.tournamentLocked = false
                self.coreDataStack.saveContext()
                self.setLockType()
                
            }))
            
            // though nothing is happening here, that just assures that the lock will still be set to true
            ac.addAction(UIAlertAction(title: "Keep On", style: .default, handler: nil))
            
            present(ac, animated: true, completion: nil)
            
        }
        
        // if the application returns with the tournament lock still set to tournament lock, and the application has just gone over the max, return true which tells the application to not add that last card to the list. So the application should still have 60/60
        return isTournamentLocked && quantityCount == 61
    }
    
    //MARK: setLockType
    func setLockType() {
        // set the displayed lock at the top to be displaying as they should using the isTournamentLocked boolean
        if isTournamentLocked {
            tournamentLock.image = UIImage(systemName: "lock.fill")
        } else {
            tournamentLock.image = UIImage(systemName: "lock.open.fill")
        }
    }
}
//MARK: - TV Data Source
extension DeckListController: UITableViewDataSource {
   
    //MARK: numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        //sections Pokemon, Trainer, Energy
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // set section headers
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
        // get the counts of each section
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
        
        // Section Pokemon
        if indexPath.section == 0 {
            // get the item of the current cell
            let item = pokemon[indexPath.row]
            // set the new values
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.id
            cell.quantityLabel.text = "x\(item.quantity)"
            
           
        // Section Trainer
        } else if indexPath.section == 1 {
            
            let item = trainer[indexPath.row]
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.id
            cell.quantityLabel.text = "x\(item.quantity)"
          
        
        // Section Energy
        } else {
            
            let item = energy[indexPath.row]
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.id
            cell.quantityLabel.text = "x\(item.quantity)"
            
            
        }
        // set the color of the cell to a darker version for all even cells
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.systemGray5
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // get current card that is being edited with trailing swipe actions
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
        
        // if current cards is nil, then there is an error, just return without effecting anything
        guard let card = currentCard else { return nil }
        
        // create a new action to add to the trailing swipe to add to the card quantity
        let add = UIContextualAction(style: .normal, title: "+") { (UIContextualAction, UIView, completion) in
            // add to the cards
            card.quantity += 1
            
            // this does two things, updates the quantity field, but also alerts you whether it needs to remove the card. In tournamentLock, you should not have cards over 60, so this will do just that
            if self.quantityCardCount() {
                card.quantity -= 1
            }
            // reload cell at current location
            tableView.reloadRows(at: [indexPath], with: .none)
            
            // set new values to the quantityCardCount
            _ = self.quantityCardCount()
            
            // mark that the swipe action is complete
            completion(true)
        }
        // set the color to the primary color (red)
        add.backgroundColor = UIColor(named: "primaryColor")
        // set the image to a larger version of the plus sign
        add.image = UIImage(systemName: "plus")
        
        // create a new action to add to the trailing swipe to remove from the card quantity
        let remove = UIContextualAction(style: .normal, title: "-") { (UIContextualAction, UIView, completion) in
            
            // if the cards quantity is at 1, the user will be alerted that the quantity is now zero, and that the card will now be removed unless they choose to cancel.
            if card.quantity == 1 {
                let ac = UIAlertController(title: "are you sure?", message: "by removing this, the card will no longer be stored localy, and will have to be re-added", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
                    // remove the card that is currently being used
                    self.deck.removeFromCards(card)
                    // get the card where the id is the same as the cell, and delete that one
                    self.cards.removeAll(where: {
                        return $0.id == card.id
                    })
                    // refresh all the cards that are being filtered
                    self.pokemonReshuffle()
                    // reload the table
                    tableView.reloadData()
                    
                }))
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(ac, animated: true, completion: nil)
            } else {
                card.quantity -= 1
                // save only the row that changed
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            // refresh quantityCardLabel
            _ = self.quantityCardCount()

            // set slideAction to complete
            completion(true)
        }
        // set background color to secondary color (blue)
        remove.backgroundColor = UIColor(named: "secondaryColor")
        remove.image = UIImage(systemName: "minus")
        
        // add these swipe actions to the configuration
        let configuration = UISwipeActionsConfiguration(actions: [add, remove])
        
        // the user cannot do a full swipe, this is not necessary
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        // when the swipe ends, it will save the context of the new quantity
        self.coreDataStack.saveContext()
    }
    
}

extension DeckListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // this is just to display the header as blue, and the color as white
        view.tintColor = UIColor(named: "secondaryColor")
        let headerView = view as! UITableViewHeaderFooterView
            headerView.textLabel?.textColor = UIColor.white
        
    }

}

