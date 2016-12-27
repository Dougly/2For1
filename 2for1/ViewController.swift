//
//  ViewController.swift
//  2for1
//
//  Created by Douglas Galante on 12/24/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let game = Game()
    
    //UI Elements
    var gameStatus: GameInfoView = GameInfoView()
    let takeActionButton = UIButton()
    let addDieButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayers()
        addViewsToVC()
    }
    
    
}

//Mark: Button Actions
extension ViewController {
    
    func takeAction(_ sender: UIButton) {
        game.playerAction()
        
        
        //print game stats for testing
        if let player = game.player {
        let turnPlayerDrinksString = "TURN: \(game.turn)  PLAYER: \(player.tag)   DRINKS: \(game.drinks)"
            gameStatus.topLabel.text = turnPlayerDrinksString
        }
        var rollsString = "ROLLS:"
        let scoreString = "  SCORE: \(game.score)"
        for die in game.dice {
            rollsString.append(" \(die.value)")
        }
        gameStatus.middleLabel.text = rollsString + scoreString
    }
    
    func addDie(_ sender: UIButton) {
        
    }
}


//MARK: Create Data
extension ViewController {
 
    func addPlayers() {
        let player1 = Player(tag: "Dougly", firstName: "Doug", lastName: "Galante")
        let player2 = Player(tag: "PlayerX", firstName: "Teddy", lastName: "Papes")
        let player3 = Player(tag: "LiveTown", firstName: "Danny", lastName: "Papes")
        self.game.players = [player1, player2, player3]
        self.game.player = game.players[0]
    }
}


//MARK: UI Constraints and Settings
extension ViewController {
    
    func addViewsToVC() {
        self.view.addSubview(gameStatus)
        self.view.addSubview(takeActionButton)
        self.view.addSubview(addDieButton)
        
        gameStatus.translatesAutoresizingMaskIntoConstraints = false
        takeActionButton.translatesAutoresizingMaskIntoConstraints = false
        addDieButton.translatesAutoresizingMaskIntoConstraints = false
        
        gameStatus.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        gameStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gameStatus.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        gameStatus.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        takeActionButton.topAnchor.constraint(equalTo: gameStatus.bottomAnchor).isActive = true
        takeActionButton.centerXAnchor.constraint(equalTo: gameStatus.centerXAnchor).isActive = true
        takeActionButton.heightAnchor.constraint(equalTo: gameStatus.heightAnchor, multiplier: 0.5).isActive = true
        takeActionButton.widthAnchor.constraint(equalTo: gameStatus.widthAnchor).isActive = true
        takeActionButton.backgroundColor = .cyan
        //Title for button needs to show
        takeActionButton.titleLabel?.text = "Take Action"
        takeActionButton.addTarget(self, action: #selector(takeAction), for: .touchUpInside)
        
        
        
    }
}
