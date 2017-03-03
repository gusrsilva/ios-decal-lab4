//
//  SearchViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var pokemonArray: [Pokemon] = []
    var filteredArray: [Pokemon] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonArray = PokemonGenerator.getPokemonArray()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Utility function to iterate through pokemon array for a single category
    func filteredPokemon(ofType type: Int) -> [Pokemon] {
        var filtered: [Pokemon] = []
        for pokemon in pokemonArray {
            if (pokemon.types.contains(PokemonGenerator.categoryDict[type]!)) {
                filtered.append(pokemon)
            }
        }
        return filtered
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "searchToCategory" {
                if let dest = segue.destination as? CategoryViewController {
                    dest.pokemonArray = filteredArray
                }
            }
        }
    }
    
    /*
     *  Collection View Functions
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PokemonGenerator.categoryDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoriesCollectionViewCell
        if let imageTitle = PokemonGenerator.categoryDict[indexPath.item] {
            cell.imageView.image = UIImage(named: imageTitle)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filteredArray = filteredPokemon(ofType: indexPath.item)
        performSegue(withIdentifier: "searchToCategory", sender: self)
    }

}
