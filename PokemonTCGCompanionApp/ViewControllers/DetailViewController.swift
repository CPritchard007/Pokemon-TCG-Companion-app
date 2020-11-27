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
    
    //MARK: - Actions
     @IBOutlet weak var addButton: UIBarButtonItem!
     
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var effectStackview: UIStackView!
    
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
    
    
    //MARK: - Funtion
    
    
    
        //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // gets the color that is relative to the type of card that is about to be displayed
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
        
        // display the higher resolution of the card
        if let imageUrl = card?.imageUrlHiRes, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                imageView.image = image
            }
        
        // display the card name and hp, if either does not exist, just display nothing
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
            // it is possible that a card has no weakness, so the default would be as displayed
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
            // it is possible that a card has no resistance, so the default would be as displayed
            resistanceValue.text = "N/A"
            resistanceImage.image = nil
            resistanceValue.textColor = UIColor.lightGray
        }
        
        if let retreat = card?.retreatCost {
            retreat.forEach { retreat in
                // get the image relative to the type the card is
                let retreatImage = UIImageView(image: UIImage(named: "Type\(retreat.rawValue)"))
                // set a new constraint within the stackView that allows the application to add as many images as needed by the retreat
                let widthConstraint = NSLayoutConstraint(item: retreatImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 25)
                retreatImage.addConstraint(widthConstraint)
                let heightContstraint = NSLayoutConstraint(item: retreatImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 25)
                retreatImage.addConstraint(heightContstraint)
                
                retreatStack.addArrangedSubview(retreatImage)
            }
        }
    }
    
    //MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest()
    }
    
    //MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeckPopover" {
            let popoverVC = segue.destination as! AddPopoverViewController
            
            popoverVC.deckList = self.deckList
            popoverVC.delegate = self
            
            // pass the custom color and its prefered text color to the addPopoverView
            popoverVC.backgroundColor = backgroundColor
            popoverVC.textColor = self.textColor
                
        }
    }
        
    //MARK: FetchRequest
    func fetchRequest () {
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        
        do {
            deckList = try coreDataStack.managedContext.fetch(fetchRequest)
        } catch {
            print("there was a problem grabbing your decks ☹️")
        }
    }
}

//MARK: - TV Data Source
extension DetailViewController: UITableViewDataSource {

    
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if let cardSuperType = card?.supertype, cardSuperType == .trainer, let trainerText = card?.text{
            return trainerText.count
        }
        
        if let attacks = card?.attacks {
            // ther is only ever one text added to the card, this is usually used only for the trainer cards, but some differences do apply, so this will assure that there is the ability to display the text
            return attacks.count + (card?.ability != nil ? 1 : 0)
        } else {
            return 0
        }
        
    }

    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // there are a total of three types of custom tableview Cells (ability cell, attack cell, and trainer cell)
        if let cardSuperType = card?.supertype, cardSuperType == .trainer, let trainerText = card?.text {
            // due to the fact that explanations of the card should be shown at the top, the text will be placed first (when applicable).
            let identifier = "TrainerTableviewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! TrainerTableViewCell

            // place the text onto the table
            cell.trainerDescription.text = trainerText[indexPath.row]
            cell.trainerDescription.textColor = textColor
            return cell
        }
        
        if let ability = card?.ability {
            // if there is an ability on the attack, then display the ability image beside the attack, this never contains a attack type.
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
                
                // if these arent the case, then the application is obviously needing to display a standard attack, so display the following
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
                        
                        // some attacks need more than one type, an example would be one that has a colourless and a darkness. this will assure that all are displayed
                        for attackValue in attackValues {
                            
                            // get the image relative to the type that needs to be displayed
                            let valueImage = UIImageView(image: UIImage(named: "Type\(attackValue)")!)
                            // set the width and height of the image to the 1:1 aspect and 30px size
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
            
            // This portion has very little difference, The only change is that in the ability code, I have "indexPath.row -1" that is used when there is an ability attached to the card. If there is no ability, this is what is used
            
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

//MARK: - AddPopoverView Delegate
extension DetailViewController: AddPopoverViewControllerDelegate {
    
    
    //MARK: addToDeck
    func addToDeck(_ viewController: UIViewController, deck: Deck, quantity: Int) {
        viewController.dismiss(animated: true)
        
        // get deck that the card is to be added to. then search the deck to see if this card is already added, if it is, add the quantity to the card, else just add a new card.
        guard let cardSet = deck.cards as? Set<Card> else { return }
        let card = cardSet.first { card -> Bool in

            return self.card.id == card.id
        }
        
        if (card == nil) {
            
            // create new card for coreData
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
            // add card to deck
            newCard.addToDecks(deck)
            
            coreDataStack.saveContext()
        
        } else {
            // add quantity to card that already exists
            card?.setValue(card!.quantity + Int32(quantity) ,forKey: "quantity")
            self.coreDataStack.saveContext()
        }
    }
}


// MARK: - Popover Custom Dwlegate
// this assures that the deck automatically updates.
protocol AddPopoverViewControllerDelegate: class {
    func addToDeck (_ viewController: UIViewController, deck: Deck, quantity: Int)
}


// MARK: AddPopoverViewController
class AddPopoverViewController: UIViewController {

    //MARK: - Popover Variables
    var backgroundColor: UIColor!
    var textColor: UIColor!
    var deckList: [Deck]!
    var delegate: AddPopoverViewControllerDelegate!
    var quantity = 1
    
    
    //MARK: - Popover Outlets
    @IBOutlet weak var deckPicker: UIPickerView!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToDeckLabel: UILabel!
    
    
    //MARK: - Popover Actions
    // This assures that the pack cannot extend past the total of 1,000 which is indeed past the total that is needed for the tournamentLock, but it is more importantly over the max that the application field can display.
    @IBAction func addButton(_ sender: Any) {
        if quantity < 1_000 {
            quantity += 1
        }
        quantityField.text = "\(quantity)"
    }
    
    // the user cannot press the subtract button to set the field to 0
    @IBAction func subtractButton(_ sender: Any) {
        if quantity > 1 {
            quantity -= 1
        }
        quantityField.text = "\(quantity)"
    }
    // add the card to deck
    @IBAction func submissionButton(_ sender: Any) {
        let deck = deckList[deckPicker.selectedRow(inComponent: 0)]
        delegate.addToDeck(self, deck: deck, quantity: quantity)
    }
    
    //MARK: - Functions
    
        
    
        //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantityField.delegate = self
        quantityField.text = "\(quantity)"
        quantityField.keyboardType = .numberPad
        quantityField.backgroundColor = .white
        quantityField.textColor = .black
        
        quantityLabel.textColor = self.textColor
        
        addToDeckLabel.textColor = self.textColor
        view.backgroundColor = self.backgroundColor.withAlphaComponent(1)

        deckPicker.delegate = self
        deckPicker.dataSource = self
    }
}

extension AddPopoverViewController: UIPickerViewDelegate {}

//MARK: - PV Data Source
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

//MARK: - TF Delegate
extension AddPopoverViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        let currentText = textField.text ?? ""
        
        // this assures that the person does not personally enter in more than 100,000
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // if the user presses the delete button when editing the textFied, the application will change the quantity back to one when there is only the ones column left
        guard let newQuantity = Int(updatedText) else {
            quantity = 1
            quantityField.text = "\(quantity)"
            return false }
        quantity = newQuantity
        guard quantity < 1_000 else { return false }
        
        return true
        
    }
}
