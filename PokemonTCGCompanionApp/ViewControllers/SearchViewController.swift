//
//  SearchViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-15.
//

import UIKit


class SearchViewController: UIViewController, UISearchResultsUpdating {
    //MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    
    
 
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: add hidable UISearchController into the pages CollectionView with Scope bar [Pokemon, Energy, Trainer]
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ENTER CARD NAME"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
