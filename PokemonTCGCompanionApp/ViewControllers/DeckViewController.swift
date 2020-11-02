//
//  DeckViewController.swift
//  PokemonTCGCompanionApp
//
//  Created by Curtis Pritchard on 2020-11-01.
//

import UIKit


class DeckViewController: UICollectionView {
    
}

extension DeckViewController: UICollectionViewDelegate {
    
}

extension DeckViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "deckCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
        
    }
    
    
}
