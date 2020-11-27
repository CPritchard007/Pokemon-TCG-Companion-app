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
    
    // this is set before it is ever used, so it is forced to be unwrapped
    var selectedIndexPath: IndexPath!
    
    
    //MARK: - Action
    @IBAction func addButton(_ sender: Any) {
        
        
        // MARK: Add Button
        // create a new Alert that allows the user to quickly add a new deck
        let ac = UIAlertController(title: "Create Deck", message: nil, preferredStyle: .alert)
        
        // allow the user to enter the name in the alert
        ac.addTextField()
        
        // add the "Submit" & "Cancel" buttons
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            if let textField = ac.textFields![0].text, textField.count > 5 {
            
                // create a new Deck for the coreDataStack
                let newDeck = Deck(context: self.coreDataStack.managedContext)
                
                // get the title from the textField, and add it to this new Deck
                newDeck.title = textField
                
                ///# Choosing a Random Color
                // In this application, the decks get a random color. As you can see below, I choose a random color from the ones provided below. It then goes through a little conversion from its RGB to a string version
                // "RED GREEN BLUE"
                // This allows the coreDataModel to store said color for when the application restarts
                switch Int.random(in: 0...9) {
                case 0:
                    newDeck.color = UIColor.purple.toString()
                case 1:
                    newDeck.color = UIColor.cyan.toString()
                case 2:
                    newDeck.color = UIColor.red.toString()
                case 3:
                    newDeck.color = UIColor.yellow.toString()
                case 4:
                    newDeck.color = UIColor.green.toString()
                case 5:
                    newDeck.color = UIColor.magenta.toString()
                case 6:
                    newDeck.color = UIColor.orange.toString()
                case 7:
                    newDeck.color = UIColor.brown.toString()
                case 8:
                    newDeck.color = UIColor.blue.toString()
                case 9:
                    newDeck.color = UIColor.systemPink.toString()
                default:
                    newDeck.color = UIColor.white.toString()
                }
                
                // generate a new ID do each deck has a different ID, allowing a person to make decks with the same name
                newDeck.id = UUID()
                
                // save the applications coreData with the new Deck added
                self.coreDataStack.saveContext()
                
                self.fetchRequest()
                self.collectionView.reloadData()
            }
        }))
        
        // display alert
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    
    //MARK: - Functions
    
    
    
        //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // create a new Gesture that allows the user to delete a deck if the collectionItem is longPressed
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        
        // create a new Gesture that allows the user to enter into the cardList page. Though this should be able to be done without making a gesture, the application constantly mistakes a long press with a tap, so this will solve the issue.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        
        // add these gestures
        collectionView.addGestureRecognizer(longPressGesture)
        collectionView.addGestureRecognizer(tapGesture)
        
    }
    
        //MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // if the application is comming back to this page, fetch from the coreDataStack and reload the collection
        fetchRequest()
        
        collectionView.reloadData()
    }
    
        //MARK: - ViewWillLayoutSubviews
    // if the application changes to landscape or vice-versa, the application will invalidate itself, and change the collectionview cell size
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    
        //MARK: FetchRequest
    func fetchRequest () {
        // get an instance of the decks
        let fetchRequest: NSFetchRequest<Deck> = Deck.fetchRequest()
        
        do {
            // if the application can get the decks from coreData
            deckList = try coreDataStack.managedContext.fetch(fetchRequest)
        } catch {
            // display the error as an alert, This is good for in development application, especially if this should never happen.
            let ac = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            
        }
    }
        //MARK: LoadTable
    func loadTable () {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
        //MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if the user is entering into the cardList page
        if segue.identifier == "toCardList" {
            // get the deckList
            let cardListVC = segue.destination as! DeckListController
            // the application would not get here if the selectedIndexPath is nil, so it is already unwrapped. pass it to the deck we are loading
            cardListVC.deck = deckList[selectedIndexPath.row]
            cardListVC.coreDataStack = self.coreDataStack
        
        // if the user is entering the SearchList
        } else if segue.identifier == "toSearchList" {
            // get the searchView
            let cardListVC = segue.destination as! SearchViewController
            
            // due to the fact that the application needs to add cards from the addPopupPage, we need to pass the coreDataStack through a couple of pages
            cardListVC.coreDataStack = self.coreDataStack

        }
    }
    
        //MARK: OnLongPress
    @objc func onLongPress (_ gestureRecognizer: UILongPressGestureRecognizer) {
        // is the user longPressing on a card, if not, this is obviously not what was intended, so dont do anything
        guard let index = collectionView.indexPathForItem(at: gestureRecognizer.location(in: collectionView)) else { return }
        
        // This is Destructive, as it will remove the cards connected to the deck, so the application will need to warn the user
        let ac = UIAlertController(title: "Are You Sure?", message: "by deleting this ", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
            // remove the deck from the collectionView, coreData, and the local list
            self.coreDataStack.managedContext.delete(self.deckList[index.row])
            self.deckList.remove(at: index.row)
            self.collectionView.reloadData()
            self.coreDataStack.saveContext()

        }))
     
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(ac, animated: true, completion: nil)
    }
        
        //MARK: OnTap
    @objc func onTap (_ gestureRecognizer: UITapGestureRecognizer) {
        
        // is the user tapping on a card, if not, this is obviously not what was intended, so dont do anything
        guard let index = collectionView.indexPathForItem(at: gestureRecognizer.location(in: collectionView)) else { return }
        
        selectedIndexPath = index
        
        // now that the selectedIndexPath has a value, go to perform the seque
        performSegue(withIdentifier: "toCardList", sender: self)
    }
}

//MARK: - CV DataSource
extension DeckViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deckList.count
    }
 
    //MARK:CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get the cell, and deck at the current position
        let identifier = "deckCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DeckCollectionCell
        let deck = deckList[indexPath.row]
        
        //this is where we are breaking apart that string version of our color
        if let colors = deck.color?.split(separator: " "){
            // I used the code for allowing me to tint the image as seen here. https://www.hackingwithswift.com/example-code/uikit/how-to-recolor-uiimages-using-template-images-and-withrenderingmode
            
            // To Understand what I am doing, let me explain. The Storyboard has 2 images on top of eachother, the back is the back of the card pack, and the front of the cardPack. By having two of these, I can essentially dye the front image, and make it look look like only one image.
            if let tintedImage = UIImage(named: "packFront") {

                let tintableImage = tintedImage.withRenderingMode(.alwaysTemplate)
                cell.frontImage.image = tintableImage
            }
            
            // use the color values we got above and pass it into the frontImage tint color.
            if let red = Float(colors[1]), let green = Float(colors[2]), let blue = Float(colors[3]) {
                cell.frontImage.tintColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
            }
        }
        
        cell.deckNameLabel.text = deck.title
        
        return cell
        
    }
    
}

//MARK: - CV Delegate Flow Layout
extension DeckViewController: UICollectionViewDelegateFlowLayout {
    
    
    //MARK: sizeForItemAt
    // THis is what allows me to justify what size the collection cell needs to be. This is less important for this page, but is crucial when I am displaying for the SearchView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // get the number of cells that can be displayed on this page, minimum of 2
        let sizePerRow: Int = max((Int(collectionView.bounds.width) / 200), 2)
        // get the width of the users screen (more specifically, the collectionView)
        let MaxWidth = self.collectionView.bounds.width
        // get the size of each of the collectionViewCells by dividing the collectionView width by the number of cells in the row
        return CGSize(width: Int(MaxWidth) / sizePerRow , height: 220)
    }
    
    //MARK: ItemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // set the spacing to 0 so the cells are tighter
        return 0.0
    }
}

//MARK: - UIColor extension
extension UIColor {
    
    //MARK: toString
    func toString () -> (String) {
        // get the color from UIColor (example being UIColor.red), and get its components. If the application where to not get anything, then the application would just return with an empty string
        guard let components = self.cgColor.components else {return ""}
        var newString = ""
        for component in components {
            // get each component in components and add it to a string
            newString += "\(component) "
        }
        // due to how I did the for loop, I have one extra space at the end, remove it
        newString.removeLast()
        
        return newString
    }
}
