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
    
    var coreDataStack = CoreDataStack(modelName: "PokemonCompanionApplication")
    
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
                
                
                switch Int.random(in: 0...9) {
                case 0:
                    print(UIColor.purple.toString())
                    newDeck.color = UIColor.purple.toString()
                case 1:
                    print(UIColor.cyan.toString())
                    newDeck.color = UIColor.cyan.toString()
                case 2:
                    print(UIColor.red.toString())
                    newDeck.color = UIColor.red.toString()
                case 3:
                    print(UIColor.yellow.toString())
                    newDeck.color = UIColor.yellow.toString()
                case 4:
                    print(UIColor.green.toString())
                    newDeck.color = UIColor.green.toString()
                case 5:
                    print(UIColor.magenta.toString())
                    newDeck.color = UIColor.magenta.toString()
                case 6:
                    print(UIColor.orange.toString())
                    newDeck.color = UIColor.orange.toString()
                case 7:
                    print(UIColor.brown.toString())
                    newDeck.color = UIColor.brown.toString()
                case 8:
                    print(UIColor.blue.toString())
                    newDeck.color = UIColor.blue.toString()
                case 9:
                    print(UIColor.white.toString())
                    newDeck.color = UIColor.systemPink.toString()
                default:
                    print(UIColor.white.toString())
                    newDeck.color = UIColor.white.toString()
                }
                
                
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
                
                
                if let cards = deckList[index.row].cards as? Set<Card> {
                    let cardsArray = Array(cards)
                    for card in cardsArray {
                        print("=> \(card)")
                    }
                }
                cardListVC.deck = deckList[index.row]
                cardListVC.coreDataStack = self.coreDataStack
            }

        } else if segue.identifier == "toSearchList" {
            let cardListVC = segue.destination as! SearchViewController
            cardListVC.coreDataStack = self.coreDataStack

        }
    }
    
    @objc func onLongPress (_ gestureRecognizer: UILongPressGestureRecognizer) {
        print("yuuuuuuuuuuuuuuuuuus")
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
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: cell, action: #selector(self.onLongPress))
        
        cell.addGestureRecognizer(longPressRecognizer)
        
        let deck = deckList[indexPath.row]
        if let colors = deck.color?.split(separator: " "){
            // https://www.hackingwithswift.com/example-code/uikit/how-to-recolor-uiimages-using-template-images-and-withrenderingmode
                        
            if let tintedImage = UIImage(named: "packFront") {
                let tintableImage = tintedImage.withRenderingMode(.alwaysTemplate)
                cell.frontImage.image = tintableImage
            }
            if let red = Float(colors[1]), let green = Float(colors[2]), let blue = Float(colors[3]) {
                cell.frontImage.tintColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
            }
        }
        else {
            print("here")
        }

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

extension UIColor {
    func toString () -> (String) {
        guard let component = self.cgColor.components else {return ""}
        var newString = ""
        for comp in component {
            
            newString += "\(comp) "
        }
        newString.removeLast()
        print(newString)
        return newString
    }
}
