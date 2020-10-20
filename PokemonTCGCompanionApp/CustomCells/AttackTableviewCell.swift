//
//  AttackTableviewCell.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-17.
//

import UIKit

class AttackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var attackNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var damageLabel: UILabel!
    
}
class AbilityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var abilityTypeImage: UIImageView!
    
    @IBOutlet weak var abilityNameLabel: UILabel!
    
    @IBOutlet weak var abilityType: UILabel!
    
    @IBOutlet weak var abilityText: UILabel!
    
    
}

class TrainerTableViewCell: UITableViewCell {
    @IBOutlet weak var trainerDescription: UILabel!
}
