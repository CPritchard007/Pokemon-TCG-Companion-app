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
    var searchbarText: String {
        return searchController.searchBar.text ?? ""
    }


    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    //MARK: - Functions
        
    
    
        //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Properties
        
        
        //MARK: collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        // dont set the background to greyscale
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ENTER CARD NAME"
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.enablesReturnKeyAutomatically = false
        // sets the titles of the searchButtons
        searchController.searchBar.scopeButtonTitles = SuperTypePlus.allCases.map{(item) in
            return item.rawValue
        }
        // set this searchController to our search page
        navigationItem.searchController = searchController
        definesPresentationContext = true
            
        // get all cards from the Pokemon API
        query()
    }
    
        // MARK: ViewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        // if the user changes orientation of the application, then invalidate the layout, and change it to fit the new width
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
 
    
        //MARK: Query
    func query(){
        var urlString: String
        // if there is text in the searchfield
        if !searchbarText.isEmpty {
            // test to see if the user has selected a filter, but hasnt added text. if so, change the url
            if selectedType == .all {
                urlString = "https://api.pokemontcg.io/v1/cards?name=\(searchbarText)"
            } else {
                urlString = "https://api.pokemontcg.io/v1/cards?name=\(searchbarText)&supertype=\(selectedType.rawValue)"
            }
        // if the user has entered text as well as selecting one of the filter buttons
        } else if selectedType != .all {
            urlString = "https://api.pokemontcg.io/v1/cards?supertype=\(selectedType)"
        } else {
            urlString = "https://api.pokemontcg.io/v1/cards"
        }
        
        // attempt to get the data from the url. and then enter the parse function, else pass the user an alert that there was an error.
        do {
            let url = URL(string: urlString)
            if let url = url {let data = try Data(contentsOf: url)
                parse(json: data)
            }
        } catch {
            let alert = UIAlertController(title: "Something Went Wrong!", message: error.localizedDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

        //MARK: Parse
    func parse (json: Data) {
        let decoder = JSONDecoder()
        do{
            // using the custom CardsAPI class, import all the information from json into an array
            let jsonCards = try decoder.decode(Cards.self, from: json)
            cards = jsonCards.cards
        } catch {
            // if there is an issue, display an alert with the error
            let alert = UIAlertController(title: "Something Went Wrong!", message: error.localizedDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
        collectionView.reloadData()
    }
    
    
        //MARK: updateSearchResults
    // when the user enters text, the application starts a little countdown before it will reload the url data. if the user keeps entering, it will cancel the last countdown and start again.
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        NSObject.cancelPreviousPerformRequests(withTarget: searchbar, selector: #selector(getCards), object: searchbar)
        self.perform(#selector(getCards),with: searchbar, afterDelay: 5)
    }
    
        //MARK: getCards
    @objc func getCards(){
        query()
    }
    
        //MARK: prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPage" {
            let destinationSegue = segue.destination as! DetailViewController
            
            if let index = collectionView.indexPathsForSelectedItems?.first?.row {
                destinationSegue.card = cards[index]
                destinationSegue.coreDataStack = self.coreDataStack
            }
        }
    }
}

//MARK: - CV Data Source
extension SearchViewController: UICollectionViewDataSource {
        
    //MARK: numberOfRowsInSelection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return cards.count
    }
    
    //MARK: cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCardCell", for: indexPath) as! SearchCollectionCell
        
        let card = cards[indexPath.row]
       
        // change a URL image to that of a UIImage and pass it to the screen
        if let imageUrl = card.imageUrl, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            cell.imgeView.image = image

        }
        return cell
    }
}


// MARK: - SB Delegate
extension SearchViewController: UISearchBarDelegate {
    
    
    //MARK: SearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    //MARK: selectedButtonWhenChanged
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

//MARK: - CV FlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
   
    
    //MARK: sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // calculate the size of the cells to fill a 3:4 aspect ratio (same as that of a pokemon card). I get the size of the screen, and calculate how many I can safely fit in one row, then I set the width and height using my earlier measurements.
        let sizePerRow: Int = max((Int(collectionView.bounds.width) / 200), 2)
        let MaxWidth = self.collectionView.bounds.width
        let cellAspect = ((Int(MaxWidth) / sizePerRow) / 3) - 2
        
        return CGSize(width: cellAspect * 3 , height: cellAspect * 4)
    }
    
    
    //MARK: spacing for collections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}


