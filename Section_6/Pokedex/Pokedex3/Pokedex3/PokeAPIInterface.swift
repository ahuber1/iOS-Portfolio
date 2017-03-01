//
//  Constants.swift
//  Pokedex3
//
//  Created by Andrew Huber on 2/28/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation

class PokeAPIInterface {
    static let URL_BASE = "http://pokeapi.co"
    static let URL_POKEMON = "/api/v1/pokemon/"
    
    static func getURLForPokemonWith(pokedexID: Int) -> URL? {
        return URL(string: "\(PokeAPIInterface.URL_BASE)\(PokeAPIInterface.URL_POKEMON)\(pokedexID)")
    }
    
    static func getURLForPokemonDescriptionWith(urlString: String) -> URL? {
        return URL(string: "\(PokeAPIInterface.URL_BASE)\(urlString)")
    }
}
