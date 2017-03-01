//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Andrew Huber on 2/17/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation
import Alamofire

typealias ErrorOccurred = (UIAlertController) -> ()
typealias DownloadDescriptionComplete = () -> ()
typealias DownloadEvolutionsComplete = () -> ()
typealias DownloadComplete = () -> ()
fileprivate let DEFAULT_STRING = ""

class Pokemon: CustomStringConvertible {
    private var _name: String!
    private var _pokedexID: Int!
    private var _pokemonDescription: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: URL!
    
    var name: String { return _name }
    var pokedexID: Int { return _pokedexID }
    var pokemonURL: URL? { return _pokemonURL }
    
    var pokemonDescription: String {
        
        if _pokemonDescription == nil {
            _pokemonDescription = DEFAULT_STRING
        }
        
        return _pokemonDescription
    }
    
    var type: String {
        if _type == nil {
            _type = DEFAULT_STRING
        }
        
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = DEFAULT_STRING
        }
        
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = DEFAULT_STRING
        }
        
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = DEFAULT_STRING
        }
        
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = DEFAULT_STRING
        }
        
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = DEFAULT_STRING
        }
        
        return _nextEvolutionText
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = DEFAULT_STRING
        }
        
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = DEFAULT_STRING
        }
        
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = DEFAULT_STRING
        }
        
        return _nextEvolutionLevel
    }
    
    var description: String {
        let              name = "               Name: \(              _name == nil ? "nil" : _name!)"
        let         pokedexID = "         Pokedex ID: \(         _pokedexID == nil ? "nil" : _pokedexID!.description)"
        let       description = "        Description: \(_pokemonDescription == nil ? "nil" : _pokemonDescription!)"
        let              type = "               Type: \(              _type == nil ? "nil" : _type!)"
        let           defense = "            Defense: \(           _defense == nil ? "nil" : _defense!)"
        let            height = "             Height: \(            _height == nil ? "nil" : _height!)"
        let            weight = "             Weight: \(            _weight == nil ? "nil" : _weight!)"
        let            attack = "             Attack: \(            _attack == nil ? "nil" : _attack!)"
        let nextEvolutionText = "Next Evolution Text: \(_nextEvolutionText == nil ? "nil" : _nextEvolutionText!)"
        let        pokemonURL = "                URL: \(        _pokemonURL == nil ? "nil" : _pokemonURL!.description)"
        
        // Return all of the strings above separated by newlines
        return "\(name)\n\(pokedexID)\n\(description)\n\(type)\n\(defense)\n\(height)\n\(weight)\n\(attack)\n\(nextEvolutionText)\n\(pokemonURL)"
    }
    
    init(withName name: String, andPokedexID pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        self._pokemonURL = PokeAPIInterface.getURLForPokemonWith(pokedexID: pokedexID)
    }
    
    func downloadPokemonDetails(downloadDescriptionComplete: @escaping DownloadDescriptionComplete, downloadComplete: @escaping DownloadComplete, errorOccurred: @escaping ErrorOccurred) {
        if let url = _pokemonURL {
            Alamofire.request(url).responseJSON { response in
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    if let weight = dict["weight"] as? String {
                        self._weight = weight
                    }
                    if let height = dict["height"] as? String {
                        self._height = height
                    }
                    if let attack = dict["attack"] as? Int {
                        self._attack = "\(attack)"
                    }
                    if let defense = dict["defense"] as? Int {
                        self._defense = "\(defense)"
                    }
                    if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                        self._type = ""
                        
                        for subdictionary in types {
                            if let name = subdictionary["name"]?.capitalized {
                                self._type! += "\(name)/"
                            }
                        }
                        
                        self._type = self._type.substring(to: self._type!.index(before: self._type!.endIndex)) // remove final "/"
                    }
                    else {
                        self._type = "[Unknown]"
                    }
                    if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>], descriptionArray.count > 0 {
                        self.downloadDescription(descriptionArray: descriptionArray, downloadDescriptionComplete: downloadDescriptionComplete, errorOccurred: errorOccurred)
                    }
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                        self.parseEvolutions(evolutions)
                    }
                    
                    downloadComplete()
                }
                else {
                    let alert = UIAlertController(title: "Could not retrieve data", message: "Although a connection to the server could be established, Pokedex could not parse the information that was retrieved.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    errorOccurred(alert)
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Could not construct URL", message: "Could not construct a URL to download data for \"\(self.name)\".", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            errorOccurred(alert)
        }
    }
    
    func downloadDescription(descriptionArray: [Dictionary<String, String>], downloadDescriptionComplete: @escaping DownloadDescriptionComplete, errorOccurred: @escaping ErrorOccurred) {
        if let uriStr = descriptionArray[0]["resource_uri"] {
            if let url = PokeAPIInterface.getURLForPokemonDescriptionWith(urlString: uriStr) {
                Alamofire.request(url).responseJSON { response in
                    if let descriptionDict = response.result.value as? Dictionary<String, AnyObject> {
                        if let description = descriptionDict["description"] as? String? {
                            self._pokemonDescription = description?.replacingOccurrences(of: "POKMON", with: "Pokemon")
                            downloadDescriptionComplete()
                        }
                    }
                    else {
                        let alert = UIAlertController(title: "Could not parse data", message: "Although a connection to the server could be established, Pokedex could not parse the information that retrieved in order to retrieve the description for the Pokemon \"\(self.name)\".", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        alert.addAction(okAction)
                        errorOccurred(alert)
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Could not construct URL", message: "Could not construct a URL to download the description for \"\(self.name)\".", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                errorOccurred(alert)
            }
        }
        else {
            let alert = UIAlertController(title: "Unable to retrieve description URL", message: "Could not retrieve the URL to download the description for \"\(self.name)\".", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            errorOccurred(alert)
        }
    }
    
    func parseEvolutions(_ evolutions: [Dictionary<String, AnyObject>]) {
        if let nextEvo = evolutions[0]["to"] as? String {
            if nextEvo.range(of: "mega") == nil { // we are excluding the "megas"
                self._nextEvolutionName = nextEvo
                
                if let uri = evolutions[0]["resource_uri"] as? String {
                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                    let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                    
                    self._nextEvolutionID = nextEvoId
                    
                    if let level = evolutions[0]["level"] as? Int {
                        self._nextEvolutionLevel = "\(level)"
                    }
                    else {
                        self._nextEvolutionLevel = ""
                    }
                }
            }
        }
    }
}
