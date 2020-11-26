//
//  DetailViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-17.
//

import UIKit
import CoreData


class DetailViewController: UIViewController, UITableViewDelegate {
    //MARK: - Variables
    
    var card: CardApi!
    var pickerType = Deck()
    var coreDataStack: CoreDataStack!
    var deckList = [Deck]()
    var backgroundColor: UIColor = UIColor()
    var textColor: UIColor = UIColor()
    
    
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
    
    @IBOutlet weak var WeaknessStack: UIStackView!
    
    
    ///#Resistance
    @IBOutlet weak var resistanceImage: UIImageView!
    @IBOutlet weak var resistanceValue: UILabel!
    
    @IBOutlet weak var resistanceStack: UIStackView!
    
    
    ///#Retreat
    @IBOutlet weak var retreatStack: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
        switch card.types?.first {
            case .some(.colorless):
                backgroundColor = .lightGray
                textColor = .darkText
                break

            case .some(.darkness):
                backgroundColor = .darkGray
                textColor = .white
                break
            case .some(.dragon):
                backgroundColor = .brown
                textColor = .white
                break
            case .some(.fairy):
                backgroundColor = .systemPink
                textColor = .darkText
                break
            case .some(.fighting):
                backgroundColor = UIColor.orange
                textColor = .white
                break
            case .some(.fire):
                backgroundColor = .red
                textColor = .white
                break
            case .some(.grass):
                backgroundColor = .systemGreen
                textColor = .white
                break
            case .some(.lightning):
                backgroundColor = .systemYellow
                textColor = .darkText
                break
            case .some(.metal):
                backgroundColor = .systemGray
                textColor = .white
                break
            case .some(.psychic):
                backgroundColor = .systemPurple
                textColor = .white
                break
            case .some(.water):
                backgroundColor = UIColor(named: "secondaryColor")!
                textColor = .white
                break
            default:
                backgroundColor = .white
                textColor = .darkText
                break
        }

        
        backgroundColor = backgroundColor.withAlphaComponent(0.8)
        view.backgroundColor = backgroundColor
        tableView.backgroundColor = backgroundColor
        
        nameLabel.textColor = textColor
        hpLabel.textColor = textColor
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        
        if let imageUrl = card?.imageUrlHiRes, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                imageView.image = image
            }
        
        
        if let name = card?.name {
            nameLabel.text = name
            if card.hp != "None" {
                hpLabel.text = "HP \(card?.hp ?? "")"
            }
        }
        
        weaknessValue.textColor = .darkText
        if let weaknesses = card?.weaknesses {
        weaknesses.forEach { weakness in
                weaknessValue.text = weakness.value
//            print("Type\(weakness.type)")
            weaknessImage.image = UIImage(named: "Type\(weakness.type.rawValue)")
            }
            
        } else {
            weaknessValue.text = "N/A"
            weaknessImage.image = nil
            weaknessValue.textColor = UIColor.lightGray
        }
        
        
        resistanceValue.textColor = .darkText
        if let resistances = card?.resistances {
        resistances.forEach { resistance in
                resistanceValue.text = resistance.value
            // print("Type\(resistance.type)")
            resistanceImage.image = UIImage(named: "Type\(resistance.type.rawValue)")
            }
        } else {
            resistanceValue.text = "N/A"
            resistanceImage.image = nil
            resistanceValue.textColor = UIColor.lightGray
        }
        
        if let retreat = card?.retreatCost {
            retreat.forEach { retreat in
                
                let retreatImage = UIImageView(image: UIImage(named: "Type\(retreat.rawValue)"))
                
                let widthConstraint = NSLayoutConstraint(item: retreatImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 25)
                retreatImage.addConstraint(widthConstraint)
                let heightContstraint = NSLayoutConstraint(item: retreatImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 25)
                retreatImage.addConstraint(heightContstraint)
                
                retreatStack.addArrangedSubview(retreatImage)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeckPopover" {
            let popoverVC = segue.destination as! AddPopoverViewController
            
            popoverVC.deckList = self.deckList
            popoverVC.delegate = self
            popoverVC.backgroundColor = backgroundColor
            popoverVC.textColor = self.textColor
            
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
            cell.trainerDescription.textColor = textColor
            return cell
        }
        
        
        if let ability = card?.ability {
            if indexPath.row == 0 {
                let identifier = "AbilityTableviewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AbilityTableViewCell
                
                cell.subviews.first?.backgroundColor = self.backgroundColor
                
                cell.abilityNameLabel.text = ability.name
                cell.abilityNameLabel.textColor = textColor

                cell.abilityText.text = ability.text
                cell.abilityText.textColor = textColor

                cell.abilityTypeImage.image = UIImage(named: "Ability\(ability.type)")
                return cell

            } else {
                let identifier = "AttackTableviewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AttackTableViewCell


                if let attacks: [Attack] = card?.attacks {
                    let attack = attacks[indexPath.row - 1]
                    
                    cell.attackNameLabel.text = attack.name
                    cell.attackNameLabel.textColor = textColor

                    cell.descriptionLabel.text = attack.text
                    cell.descriptionLabel.textColor = textColor

                    cell.damageLabel.text = attack.damage
                    cell.damageLabel.textColor = textColor

                    
                    if let attackValues = attack.cost {
                        for attackValue in attackValues {
                            
                            let valueImage = UIImageView(image: UIImage(named: "Type\(attackValue)")!)
                            
                            let widthConstraint = NSLayoutConstraint(item: valueImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30)
                            valueImage.addConstraint(widthConstraint)
                            let heightContstraint = NSLayoutConstraint(item: valueImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30)
                            
                            valueImage.addConstraints([widthConstraint,heightContstraint])
                            cell.valueStack.addArrangedSubview(valueImage)
                        }
                    }
                }
                    
                return cell
            }
            
        } else {
            let identifier = "AttackTableviewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AttackTableViewCell


            if let attacks: [Attack] = card?.attacks {
                let attack = attacks[indexPath.row]
                
                cell.attackNameLabel.text = attack.name
                cell.attackNameLabel.textColor = textColor
                
                cell.descriptionLabel.text = attack.text
                cell.descriptionLabel.textColor = textColor
                
                cell.damageLabel.text = attack.damage
                cell.damageLabel.textColor = textColor
                
                if let attackValues = attack.cost {
                    for attackValue in attackValues {
                        let valueImage = UIImageView(image: UIImage(named: "Type\(attackValue)")!)
                        
                        let widthConstraint = NSLayoutConstraint(item: valueImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 25)
                        valueImage.addConstraint(widthConstraint)
                        let heightContstraint = NSLayoutConstraint(item: valueImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 25)
                        
                        valueImage.addConstraints([widthConstraint,heightContstraint])
                        cell.valueStack.addArrangedSubview(valueImage)
                    }
                }
            }
            
            return cell
        }
    }
}

extension DetailViewController: AddPopoverViewControllerDelegate {
    func addToDeck(_ viewController: UIViewController, deck: Deck, quantity: Int) {
        viewController.dismiss(animated: true)
        
        
        guard let cardSet = deck.cards as? Set<Card> else { return }
        let card = cardSet.first { card -> Bool in

            return self.card.id == card.id
        }
        
        if (card == nil) {
            let newCard = Card(context: coreDataStack.managedContext)
            
            newCard.id = self.card.id
            newCard.hp = self.card.hp
            newCard.name = self.card.name
            
            if let nationalPokedexNumber = self.card.nationalPokedexNumber {
                newCard.nationalPokedexNumber = Int32(nationalPokedexNumber)
            }
            
            newCard.superType = self.card.supertype.rawValue
            newCard.subType = self.card.supertype.rawValue
            
            if let types = self.card.types {
                let newTypes: [String] = types.map {$0.rawValue}
                newCard.type = newTypes
                
            }
            
            if let text = self.card.text {
                newCard.text = text
            }
            
            newCard.rarity = self.card.rarity
            newCard.quantity = Int32(quantity)
            newCard.addToDecks(deck)
            
            coreDataStack.saveContext()
        
        } else {
        
            card?.setValue(card!.quantity + Int32(quantity) ,forKey: "quantity")
            self.coreDataStack.saveContext()
        }
    }
}



protocol AddPopoverViewControllerDelegate: class {
    func addToDeck (_ viewController: UIViewController, deck: Deck, quantity: Int)
}

class AddPopoverViewController: UIViewController {
    var backgroundColor: UIColor!
    var textColor: UIColor!
    var deckList: [Deck]!
    var delegate: AddPopoverViewControllerDelegate!
    var quantity = 1
    
    @IBOutlet weak var deckPicker: UIPickerView!
    
    @IBOutlet weak var quantityField: UITextField!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToDeckLabel: UILabel!
    
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
        let deck = deckList[deckPicker.selectedRow(inComponent: 0)]
        delegate.addToDeck(self, deck: deck, quantity: quantity)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityField.delegate = self
        quantityField.text = "\(quantity)"
        quantityField.keyboardType = .numberPad
        
        quantityLabel.textColor = self.textColor
        addToDeckLabel.textColor = self.textColor
        
        deckPicker.delegate = self
        deckPicker.dataSource = self
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        view.backgroundColor = self.backgroundColor.withAlphaComponent(1)
        quantityField.backgroundColor = .white
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

