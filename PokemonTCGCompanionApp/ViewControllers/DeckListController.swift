//
//  DeckListController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-11-10.
//

import UIKit

class DeckListController: UIViewController {
    
    //MARK: - Variables
    var templateItems = [Item]()
    var isTournamentLocked: Bool = false
    
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
        
        templateItems.append(Item(name: "Temporary Name", ID: "Basel - 116", quantity: "x99", supertype: .trainer))
        templateItems.append(Item(name: "Temporary Name", ID: "Basel - 116", quantity: "x99", supertype: .pokemon))
        templateItems.append(Item(name: "Temporary Name", ID: "Basel - 116", quantity: "x99", supertype: .energy))
        templateItems.append(Item(name: "Temporary Name", ID: "Basel - 116", quantity: "x99", supertype: .energy))
        templateItems.append(Item(name: "Temporary Name", ID: "Basel - 116", quantity: "x99", supertype: .pokemon))
        templateItems.append(Item(name: "Temporary Name", ID: "Basel - 116", quantity: "x99", supertype: .trainer))
        templateItems.append(Item(name: "Temporary Name", ID: "Basel - 116", quantity: "x99", supertype: .trainer))
        

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
        deckCountLabel.text = "\(templateItems.count)/60"
        
        switch section {
        case 0:
            return templateItems.filter {$0.supertype == .pokemon}.count
            
        case 1:
            return templateItems.filter {$0.supertype == .trainer}.count
        case 2:
            return templateItems.filter {$0.supertype == .energy}.count
           
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DeckListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DeckListCell
        
        let pokemon = templateItems.filter {$0.supertype == .pokemon}
        let trainers = templateItems.filter {$0.supertype == .trainer}
        let energy = templateItems.filter {$0.supertype == .energy}
        
        if indexPath.section == 0 {
            
            let item = pokemon[indexPath.row]
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.ID
            cell.quantityLabel.text = item.quantity
            
            if indexPath.row % 2 == 0 {
                print(indexPath.row)
                cell.backgroundColor = UIColor.systemGray5
            }
            
            return cell
        } else if indexPath.section == 1 {
            
            let item = trainers[indexPath.row]
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.ID
            cell.quantityLabel.text = item.quantity
            
            if indexPath.row % 2 == 0 {
                print(indexPath.row)
                cell.backgroundColor = UIColor.systemGray5
            }
            
            return cell
        } else {
            
            let item = energy[indexPath.row]
            cell.nameLabel.text = item.name
            cell.idLabel.text = item.ID
            cell.quantityLabel.text = item.quantity
            
            if indexPath.row % 2 == 0 {
                print(indexPath.row)
                cell.backgroundColor = UIColor.systemGray5
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            print("delete")
        default:
          print("")
        }
    }
    
}

extension DeckListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "primaryColor")
        let headerView = view as! UITableViewHeaderFooterView
            headerView.textLabel?.textColor = UIColor.white
        
    }

}

class Item {
    let name: String
    let ID: String
    let quantity: String
    let supertype: SuperType
    
    init(name: String, ID: String, quantity: String, supertype: SuperType) {
        self.name = name
        self.ID = ID
        self.quantity = quantity
        self.supertype = supertype
    }
}

