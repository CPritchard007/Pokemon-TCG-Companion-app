//
//  SearchViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-10-15.
//

import UIKit
/**
 this screen uses the searchbar thats tutorial can be found here:
    https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started
 */

class SearchViewController: UIViewController, UISearchResultsUpdating {
  
    

    //MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    var cards = [Card]()

    
    var isSearchbarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchbarEmpty
    }
    var filteredCards: [Card] = []

    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        //TODO: add hidable UISearchController into the pages CollectionView with Scope bar [Pokemon, Energy, Trainer]
       // MARK: - SearchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ENTER CARD NAME"
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.enablesReturnKeyAutomatically = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
        query(name: nil)
    }
    
    //MARK: query
    func query(name: String?){
        var urlString: String
        if let name = name {
             urlString = "https://api.pokemontcg.io/v1/cards?name=\(name)"
        } else {
             urlString = "https://api.pokemontcg.io/v1/cards"
        }
        
        do {
            let url = URL(string: urlString)
            if let url = url {let data = try Data(contentsOf: url)
                parse(json: data)
            }
        } catch let error {
            let alert = UIAlertController(title: "Something Went Wrong!", message: "Error: \(error)" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    //MARK: - parse
    func parse (json: Data) {
        let decoder = JSONDecoder()
        do{
            let jsonCards = try decoder.decode(Cards.self, from: json)
            cards = jsonCards.cards
        } catch let error {
            let alert = UIAlertController(title: "Something Went Wrong!", message: "Error: \(error)" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getCards), object: searchbar)
        self.perform(#selector(getCards),with: searchbar, afterDelay: 0.2)
        
        
    }
    
    @objc func getCards () {
        query(name: searchController.searchBar.text!)
    }

}

extension SearchViewController: UICollectionViewDelegate {

}

extension SearchViewController: UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCardCell", for: indexPath) as! SearchCollectionCell
        
        let card = cards[indexPath.row]

        if let imageURL = card.imageUrl ,let url = URL(string: imageURL), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            cell.imgeView.image = image
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

