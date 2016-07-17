//
//  Pokemon.swift
//  PokeDex
//
//  Created by Mostafa S Taheri on 7/5/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name : String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var name : String {
        get {
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            return _pokedexId
        }
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            
            return _description
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            
            return _type
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            
            return _defense
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
            
            return _height
        }
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        
        return _nextEvolutionText
    }
    
    var nextEvolutionId: String {
        get {
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
           _nextEvolutionId = ""
        }
            return _nextEvolutionLvl
    }
    
    
    //whenever you make a pokemon object it MUST have a name and ID. "you cannot even create a Pokemon object uless you pass in Pokemon name and ID and initialize the object's url
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    
    func downloadPokemonDetails(completed: downloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response  in
            let result = response.result
            
            //print(result.value.debugDescription)
            
            //convert the JSON into an iOS Swift Dictionary so we can use it
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                //NOW! all we need to do is to grab fields/data out of it
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
                
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                            self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    //grab the very first description and in that desc grab the field "resource_uri"
                    if let descUrl = descArr[0]["resource_uri"] {
                        let nsURL = NSURL(string: "\(URL_BASE)\(descUrl)")!
                        
                        Alamofire.request(.GET, nsURL).responseJSON { response  in
                            let desResult = response.result
                            
                            //print(result.value.debugDescription)
                            
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed()
                    }
                    
                } else {
                    self._description = ""
                  }
                }
                
                if let evolutionDict = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutionDict.count > 0 {
                    
                    if let nextEvolName = evolutionDict[0]["to"] as? String {
                        
                        //can't support mega pokemon right now but pokemon api still has mega data
                        if nextEvolName.rangeOfString("Mega") == nil {
                          
                            if let uri = evolutionDict[0]["resource_uri"] as? String {
                                
                                let newUri = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let pokemonNum = newUri.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                //to pull up the next evolution image
                                self._nextEvolutionId = pokemonNum
                                self._nextEvolutionText = nextEvolName
                                
                                if let lvl = evolutionDict[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                //print (self._nextEvolutionText)
                                //print(self._nextEvolutionLvl)
                                //print(self._nextEvolutionId)
                                
                                
                            }
                        }
                        
                        
                    }
                    
            }
        }

  }
}
}

