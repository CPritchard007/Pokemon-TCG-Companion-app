//
//  DetailViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-17.
//

import UIKit
import CoreData

protocol DetailViewControllerDelegate {
    func getSubmittedDeck (_ viewController: UIViewController, deck: Deck)
}

class DetailViewController: UIViewController, UITableViewDelegate {
    //MARK: - Variables
    
    var delegate: DetailViewControllerDelegate!
    var card: CardApi!
    var pickerType = Deck()
    lazy var coreDataStack = CoreDataStack(modelName: "PokemonCompanionApplication")
    var deckList = [Deck]()
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var effectStackview: UIStackView!
    
    
    //MARK: - Actions
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    
    ///#WEAKNESS
    @IBOutlet weak var weaknessImage: UIImageView!
    @IBOutlet weak var weaknessValue: UILabel!
    
    ///#Resistance
    @IBOutlet weak var resistanceImage: UIImageView!
    @IBOutlet weak var resistanceValue: UILabel!
    
    ///#Retreat
    @IBOutlet weak var retreatImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        
        if let imageUrl = card?.imageUrlHiRes, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                imageView.image = image
            }
        
        
        if let name = card?.name {
            print(name)
            nameLabel.text = name
            hpLabel.text = card?.hp ?? ""
        }
        
        
        if let weaknesses = card?.weaknesses {
        weaknesses.forEach { weakness in
                print(weakness)
                weaknessValue.text = weakness.value
            }
        } else {
            weaknessValue.text = "N/A"
            weaknessValue.textColor = UIColor.lightGray
        }
        if let resistances = card?.resistances {
        resistances.forEach { resistance in
                print(resistance)
                resistanceValue.text = resistance.value
            }
        } else {
            resistanceValue.text = "N/A"
            resistanceValue.textColor = UIColor.lightGray
        }
        
        if let retreat = card?.retreatCost {
        retreat.forEach { retreat in
                print(retreat)
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeckPopover" {
            let popoverVC = segue.destination as? AddPopoverViewController
            
            popoverVC?.deckList = self.deckList
            popoverVC?.detailViewController = self
            
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRequest()
    }
    
    func fetchRequest () {
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        
        do {
            deckList = try coreDataStack.managedContext.fetch(fetchRequest)
        } catch {
            print("there was a problem grabbing your decks ☹️")
        }
    }
}

extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if let cardSuperType = card?.supertype, cardSuperType == .trainer, let trainerText = card?.text{
            return trainerText.count
        }
        
        if let attacks = card?.attacks {
            return attacks.count + (card?.ability != nil ? 1 : 0)
        } else {
            return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cardSuperType = card?.supertype, cardSuperType == .trainer, let trainerText = card?.text {
            let identifier = "TrainerTableviewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! TrainerTableViewCell
            
            cell.trainerDescription.text = trainerText[indexPath.row]
            
            return cell
        }
        
        
        
        if let ability = card?.ability {
            if indexPath.row == 0 {
                let identifier = "AbilityTableviewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AbilityTableViewCell
                cell.abilityNameLabel.text = ability.name
                cell.abilityText.text = ability.text
                cell.abilityTypeImage.image = UIImage(named: "abilityImage")
                return cell

            } else {
                let identifier = "AttackTableviewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AttackTableViewCell
                if let attacks: [Attack] = card?.attacks {
                    let attack = attacks[indexPath.row - 1]
                    cell.attackNameLabel.text = attack.name
                    cell.descriptionLabel.text = attack.text
                    cell.damageLabel.text = attack.damage
//                    if let type = attack.cost?.first?.rawValue {
//                        cell.typeImageView.image = UIImage(named: "Type\(type)")
//                    }
                }
                return cell
            }
            
        } else {
            let identifier = "AttackTableviewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AttackTableViewCell
            if let attacks: [Attack] = card?.attacks {
                let attack = attacks[indexPath.row]
                cell.attackNameLabel.text = attack.name
                cell.descriptionLabel.text = attack.text
                cell.damageLabel.text = attack.damage
            }
            
            return cell
        }
    }
}

extension DetailViewController: DetailViewControllerDelegate {
    func getSubmittedDeck(_ viewController: UIViewController, deck: Deck) {
        viewController.dismiss(animated: true)
        
        let newCard = Card(context: coreDataStack.managedContext)
        
        newCard.id = card.id
        newCard.hp = card.hp
        newCard.name = card.name
        // newCard.nationalPokedexNumber = Int32(card.nationalPokedexNumber)
        newCard.superType = card.supertype.rawValue
        newCard.subType = card.supertype.rawValue
        
        newCard.addToDeck(deck)
    }
}

extension DetailViewController: UIPopoverPresentationControllerDelegate {
    
}



class AddPopoverViewController: UIViewController {
    
    var detailViewController: UIViewController!
    var deckList: [Deck]!
    
    var quantity = 1
    
    @IBOutlet weak var deckPicker: UIPickerView!
    
    @IBOutlet weak var quantityField: UITextField!
    
    @IBAction func addButton(_ sender: Any) {
        if quantity < 100000 {
            quantity += 1
        }
        quantityField.text = "\(quantity)"
    }
    @IBAction func subtractButton(_ sender: Any) {
        if quantity > 1 {
            quantity -= 1
        }
        quantityField.text = "\(quantity)"
    }
    @IBAction func submissionButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityField.delegate = self
        quantityField.text = "\(quantity)"
        quantityField.keyboardType = .numberPad
        
        deckPicker.delegate = self
        deckPicker.dataSource = self
        
    }
}

extension AddPopoverViewController: UIPickerViewDelegate {
    
}
extension AddPopoverViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        deckList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return deckList[row].title
    }
    
}


extension AddPopoverViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        quantity = Int(updatedText)!
        return updatedText.count <= 6
    }
    
}
