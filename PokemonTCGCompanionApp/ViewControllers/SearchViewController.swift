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
// display the tappable filters using these enumerated items
enum SuperTypePlus: String, CaseIterable {
    case all = "All"
    case pokemon = "Pokémon"
    case trainer = "Trainer"
    case energy = "Energy"
}

class SearchViewController: UIViewController, UISearchResultsUpdating {
  
    //MARK: - Variables    
    let searchController = UISearchController(searchResultsController: nil)
    let pageSize = 20
    var cards = [CardApi]()
    var cardImage = [UIImage]()
    var coreDataStack: CoreDataStack!
    var selectedType: SuperTypePlus = .all
    var dataSource: UICollectionViewDiffableDataSource<Section, Card>! = nil

    var searchbarText: String {
        return searchController.searchBar.text ?? ""
    }


    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Properties
        
        
        
        //MARK: collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        
        //TODO: add hidable UISearchController into the pages CollectionView with Scope bar [Pokemon, Energy, Trainer]
       // MARK: SearchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ENTER CARD NAME"
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.scopeButtonTitles = SuperTypePlus.allCases.map{(item) in
            return item.rawValue
        }
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        // get all cards from the Pokemon API
        query()
    }
    
    
    // MARK: - ViewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
 
    
    //MARK: - query
    func query(){
        var urlString: String

        if !searchbarText.isEmpty {
            if selectedType == .all {
                urlString = "https://api.pokemontcg.io/v1/cards?name=\(searchbarText)&page=1&pageSize=\(pageSize)"
            } else {
                urlString = "https://api.pokemontcg.io/v1/cards?name=\(searchbarText)&supertype=\(selectedType.rawValue)&page=1&pageSize=\(pageSize)"
            }
        
        } else if selectedType != .all {
            urlString = "https://api.pokemontcg.io/v1/cards?supertype=\(selectedType)&page=1&pageSize=\(pageSize)"
        } else {
            urlString = "https://api.pokemontcg.io/v1/cards?page=1&pageSize=\(pageSize)"
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
    
    //MARK: - updateSearchResults
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        
        NSObject.cancelPreviousPerformRequests(withTarget: searchbar, selector: #selector(getCards), object: searchbar)
        self.perform(#selector(getCards),with: searchbar, afterDelay: 1)
    }
    
    //MARK: - getCards
    @objc func getCards(){
        query()
    }
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationSegue = segue.destination as? DetailViewController else { return }
        if let index = collectionView.indexPathsForSelectedItems?.first?.row {
            destinationSegue.card = cards[index]
            destinationSegue.coreDataStack = self.coreDataStack
        }
    }

}

extension SearchViewController: UICollectionViewDataSource {
        
    //MARK: - numberOfRowsInSelection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return cards.count
    }
    
    //MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCardCell", for: indexPath) as! SearchCollectionCell
        
        let card = cards[indexPath.row]
       
        if let imageUrl = card.imageUrl, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            cell.imgeView.image = image

        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    //MARK: - selectedButtonWhenChanged
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        switch selectedScope {
        case 0:
            selectedType = .all
        case 1:
            selectedType = .pokemon
        case 2:
            selectedType = .trainer
        case 3:
            selectedType = .energy
        default:
            selectedType = .all
        }
        
        query()
    }
}


extension SearchViewController: UICollectionViewDelegateFlowLayout {
   
    
    //MARK: - sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizePerRow: Int = max((Int(collectionView.bounds.width) / 200), 2)
        let MaxWidth = self.collectionView.bounds.width
        let cellAspect = ((Int(MaxWidth) / sizePerRow) / 3) - 2
        
        return CGSize(width: cellAspect * 3 , height: cellAspect * 4)
    }
    
    
    //MARK: - spacing for collections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}


