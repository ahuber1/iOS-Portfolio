//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Andrew Huber on 2/17/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: Double!
    private var _weight: Double!
    private var _attack: String!
    private var _nextEvolutionText: String!
    
    var name: String { return _name }
    var pokedexID: Int { return _pokedexID }
    
    init(withName name: String, andPokedexID pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
    }
}
