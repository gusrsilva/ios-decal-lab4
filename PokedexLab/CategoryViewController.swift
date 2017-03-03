//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "categoryToDetail" {
                if let dest = segue.destination as? PokemonInfoViewController {
                    dest.pokemon = pokemon!
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = pokemonArray {
            return arr.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonRow", for: indexPath) as! PokemonTableViewCell
        if let arr = pokemonArray {
            
            let currentPokemon: Pokemon = arr[indexPath.item]
            cell.name.text = currentPokemon.name
            if let number = currentPokemon.number {
                cell.number.text = "#\(number)"
            }
            if let attack = currentPokemon.attack {
                if let defense = currentPokemon.defense {
                    if let health = currentPokemon.health {
            cell.stats.text = "\(attack) / \(defense) / \(health)"
                    }
                }
            }
            
            // CODE FOR IMAGE
            if let image = cachedImages[indexPath.row] {
                cell.pokemonImage.image = image // may need to change this!
            } else {
                let url = URL(string: currentPokemon.imageUrl)!
                let session = URLSession(configuration: .default)
                let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                    if let e = error {
                        print("Error downloading picture: \(e)")
                    } else {
                        if let _ = response as? HTTPURLResponse {
                            if let imageData = data {
                                let image = UIImage(data: imageData)
                                self.cachedImages[indexPath.row] = image
                                cell.pokemonImage.image = UIImage(data: imageData) // may need to change this!
                                
                            } else {
                                print("Couldn't get image: Image is nil")
                            }
                        } else {
                            print("Couldn't get response code")
                        }
                    }
                }
                downloadPicTask.resume()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let arr = pokemonArray {
            pokemon = arr[indexPath.item]
        }
        performSegue(withIdentifier: "categoryToDetail", sender: self)
    }
}
