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
    let decks = ["item 1", "item 2", "item 3", "item 4", "item 5", "item 6", "item 6", "item 7"]
    var deckList = [Deck]()
    lazy var coreDataStack = CoreDataStack(modelName: "PokemonCompanionApplication")
    
    
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
    
    
}

extension DeckViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizePerRow: Int = max((Int(collectionView.bounds.width) / 200), 2)
        let MaxWidth = self.collectionView.bounds.width
        let cellAspect = ((Int(MaxWidth) / sizePerRow) / 3) - 2
        
        print("cell Width: \(cellAspect * 3); cell Height: \(cellAspect * 4)")
        return CGSize(width: cellAspect * 3 , height: cellAspect * 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
}
