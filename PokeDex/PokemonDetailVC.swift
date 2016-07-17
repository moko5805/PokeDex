//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Mostafa S Taheri on 7/9/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    var transferredPoke: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "\(transferredPoke.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        nameLbl.text = transferredPoke.name
        
        transferredPoke.downloadPokemonDetails { 
            //this will be called after download is done. download is asynchronous and you define clusure to avoid crash
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLbl.text = transferredPoke.description
        typeLbl.text = transferredPoke.type
        defenseLbl.text = transferredPoke.defense
        heightLbl.text = transferredPoke.height
        pokedexIdLbl.text = "\(transferredPoke.pokedexId)"
        weightLbl.text = transferredPoke.weight
        attackLbl.text = transferredPoke.attack
        
        if transferredPoke.nextEvolutionId == "" {
            evoLbl.text = "NO EVOLUTIONS"
            //stack view will center the image for us
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: transferredPoke.nextEvolutionId)
            var str = "NEXT EVOLUTION: \(transferredPoke.nextEvolutionText)"
            
            if transferredPoke.nextEvolutionLvl != "" {
                str += " - LVL \(transferredPoke.nextEvolutionLvl)"
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
