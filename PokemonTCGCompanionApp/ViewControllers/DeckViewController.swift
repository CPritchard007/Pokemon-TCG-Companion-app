//
//  DeckViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-11-01.
//

import UIKit
import CoreData


class DeckViewController: UIViewController {
    //MARK: - Variables

    var deckList = [Deck]()
    lazy var coreDataStack = CoreDataStack(modelName: "PokemonCompanionApplication")
    var selectedItem: Int!
    @IBAction func addButton(_ sender: Any) {
        let ac = UIAlertController(title: "New Deck", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
                
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (alertAction) in
            if let textField = ac.textFields![0].text, textField.count > 5 {
                
                let newDeck = Deck(context: self.coreDataStack.managedContext)
                
                newDeck.title = textField
                newDeck.id = UUID()
                self.coreDataStack.saveContext()
                self.presentingViewController?.dismiss(animated: true, completion: {
                    
                })
                self.fetchRequest()
                self.collectionView.reloadData()
            }
        }))
        present(ac, animated: true, completion: nil)
    }
    
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest()
        
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    
    func fetchRequest () {
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        
        do {
            deckList = try coreDataStack.managedContext.fetch(fetchRequest)
        } catch {
            print("there was a problem grabbing your decks ☹️")
        }
    }
    
    func loadTable () {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCardList" {
            let cardListVC = segue.destination as! DeckListController
            if let index = collectionView.indexPathsForSelectedItems?.first {
                cardListVC.deck = deckList[index.row]
            }
        }
    }
}

extension DeckViewController: UICollectionViewDelegate {
    
    
}

extension DeckViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deckList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "deckCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DeckCollectionCell
        
        let deck = deckList[indexPath.row]
        cell.deckImage.image = UIImage(systemName: "giftcard.fill")
        cell.deckNameLabel.text = deck.title
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.row
    }
    
}

extension DeckViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizePerRow: Int = max((Int(collectionView.bounds.width) / 200), 2)
        let MaxWidth = self.collectionView.bounds.width
        let cellAspect = ((Int(MaxWidth) / sizePerRow) / 3) - 2
        
        print("cell Width: \(cellAspect * 3); cell Height: \(cellAspect * 4)")
        return CGSize(width: cellAspect * 3 , height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}
