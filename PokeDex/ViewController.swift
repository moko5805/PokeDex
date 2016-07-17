//
//  ViewController.swift
//  PokeDex
//
//  Created by Mostafa S Taheri on 7/5/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    @IBOutlet weak var collectioView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemonSet = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var isInSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectioView.delegate = self
        collectioView.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCSV()
        
    }
    
    func initAudio() {
        
        let pathX = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(string: pathX)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV() {
        
        let csvPath = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: csvPath)
            let rows = csv.rows
            
            //print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)

                pokemonSet.append(poke)
            }
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
        
    }
    
    //this will be called 718 times, because every time we need a new cell, this function is called
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokeCell {
            
            //let pokemon = Pokemon(name: "Test", pokedexId: indexPath.row)
            let poke : Pokemon!
            
            if !isInSearchMode {
                poke = pokemonSet[indexPath.row]
            } else {
                poke = filteredPokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke : Pokemon!
        
        if isInSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemonSet[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //you should never hard code this, it should always be dynamic
        //return 718
        
        if !isInSearchMode {
            return pokemonSet.count
        }
            return filteredPokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    @IBAction func onMusicPressed(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isInSearchMode = false
            //get rid of the keyboard
            view.endEditing(true)
            collectioView.reloadData()
        } else {
            isInSearchMode = true
            let textInSearchBar = searchBar.text!.lowercaseString
            //$0 is like var somePokemon = Pokemon[$0] and $0 instead of "23" does this for all the pokemons in the array
            //we are filtering the array by the name
            filteredPokemon = pokemonSet.filter({$0.name.rangeOfString(textInSearchBar) != nil})
            collectioView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let pokeDetailVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    pokeDetailVC.transferredPoke = poke
                }
                
            }
        }
    }
    
}




    





