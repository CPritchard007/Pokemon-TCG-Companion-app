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
    
    func loadTable () {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "creationPopover" {
            let popupVC = segue.destination as! DeckCreationViewController
            popupVC.collectionView = collectionView
            
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





class DeckCreationViewController: UIViewController {
    
    lazy var coreDataStack = CoreDataStack(modelName: "PokemonCompanionApplication")
    
    var collectionView: UICollectionView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        var al: UIAlertController
        if let text = textField.text , text.count >= 5 {
            print(text)
            al = UIAlertController(title: nil, message: text, preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(al, animated: true, completion: nil)
            
            let newDeck = Deck(context: coreDataStack.managedContext)
            
            newDeck.title = text
            
            coreDataStack.saveContext()
            textField.resignFirstResponder()
            self.presentingViewController?.dismiss(animated: true, completion: {
                
            })
        } else if let text = textField.text, text.count < 5 {
             al = UIAlertController(title: nil, message: "The name you have entered is too small", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
        } else {
             al = UIAlertController(title: nil, message: "Something went wrong here", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        }

        present(al, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
