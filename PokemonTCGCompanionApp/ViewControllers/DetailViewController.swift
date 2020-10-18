//
//  DetailViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-17.
//

import UIKit

class DetailViewController: UIViewController     {
    //MARK: - Variables
    var card: Card?
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        
        if let imageUrl = card?.imageUrlHiRes, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                imageView.image = image
            }
        
        
        if let name = card?.name, let hp = card?.hp  {
            print(name)
            nameLabel.text = name
           print(hp)
            hpLabel.text = hp
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
