//
//  ViewController.swift
//  2for1
//
//  Created by Douglas Galante on 12/24/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var gameStatus: GameInfoView = GameInfoView()
    
    let rollDiceButton = UIButton()
    let addDieButton = UIButton()
    
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToVC()
    }
    
    
}

//Mark: Button Actions
extension ViewController {
    
    func rollDice(_ sender: UIButton) {
        
    } 
    
    func addDie(_ sender: UIButton) {
        
    }
}


//MARK: Create Data
extension ViewController {
 
    func addPlayers() {
        let player1 = Player(tag: "p1", firstName: "Doug", lastName: "Galante")
        let player2 = Player(tag: "p2", firstName: "Teddy", lastName: "Papes")
        let player3 = Player(tag: "p3", firstName: "Danny", lastName: "Papes")
        self.game.players = [player1, player2, player3]
        self.game.player = game.players[0]
    }
}


//MARK: Constraints
extension ViewController {
    
    func addViewsToVC() {
        self.view.addSubview(gameStatus)
        self.view.addSubview(rollDiceButton)
        self.view.addSubview(addDieButton)
        
        gameStatus.translatesAutoresizingMaskIntoConstraints = false
        rollDiceButton.translatesAutoresizingMaskIntoConstraints = false
        addDieButton.translatesAutoresizingMaskIntoConstraints = false
        
        gameStatus.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        gameStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gameStatus.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        gameStatus.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        gameStatus.contentView.backgroundColor = .gray
        gameStatus.label.textColor = .white
        
    }
}
