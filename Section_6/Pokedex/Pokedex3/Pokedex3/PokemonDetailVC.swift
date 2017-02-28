//
//  PokemonViewController.swift
//  Pokedex3
//
//  Created by Andrew Huber on 2/18/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var currentEvolutionImageView: UIImageView!
    @IBOutlet weak var nextEvolutionImageView: UIImageView!
    @IBOutlet weak var nameImage: UIImageView!
    
    override var prefersStatusBarHidden: Bool { return true } // hides status bar
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
