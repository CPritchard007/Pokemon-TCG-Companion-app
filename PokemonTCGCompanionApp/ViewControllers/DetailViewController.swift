//
//  DetailViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-17.
//

import UIKit

class DetailViewController: UIViewController {

    var card: Card?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        if let imageUrl = card?.imageUrlHiRes, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            imageView.image = image
        }
    }
    
}
