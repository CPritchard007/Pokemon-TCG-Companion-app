//
//  DetailViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-17.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate     {
    //MARK: - Variables
    var card: CardApi?
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var effectStackview: UIStackView!
    
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
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        
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

