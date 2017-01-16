//
//  ViewController.swift
//  2for1
//
//  Created by Douglas Galante on 12/24/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    let game = Game()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //UI Elements
    var gameStatus: GameInfoView = GameInfoView()
    var addDieOrDrinkView: AddDieOrDrinkView = AddDieOrDrinkView()
    let takeActionButton = UIButton()
    let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
}

//Mark: Button Actions
extension GameViewController {
    
    func takeAction(_ sender: UIButton) {
        game.playerAction()
        updateGameStatus()
    }
    
    func addDie() {
        game.addDie()
        updateGameStatus()
    }
    
    func drink() {
        game.drink()
        updateGameStatus()
    }
    
    func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //print game stats for testing
    func updateGameStatus() {
        if let player = game.player {
            let turnPlayerDrinksString = "TURN: \(game.turn)  PLAYER: \(player.tag!)   DRINKS: \(game.drinks)"
            gameStatus.topLabel.text = turnPlayerDrinksString
        }
        var rollsString = "DICE:"
        let scoreString = "  SCORE: \(game.score)"
        for die in game.dice {
            rollsString.append(" \(die.value)")
        }
        gameStatus.middleLabel.text = rollsString + scoreString
        gameStatus.bottomLabel.text = game.instructions
    }
}

//MARK: UI Constraints and Settings
extension GameViewController {
    
    func layoutViews() {
        self.view.addSubview(gameStatus)
        self.view.addSubview(takeActionButton)
        self.view.addSubview(addDieOrDrinkView)
        self.view.addSubview(backButton)
        
        gameStatus.translatesAutoresizingMaskIntoConstraints = false
        takeActionButton.translatesAutoresizingMaskIntoConstraints = false
        addDieOrDrinkView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        gameStatus.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        gameStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gameStatus.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        gameStatus.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        takeActionButton.topAnchor.constraint(equalTo: gameStatus.bottomAnchor).isActive = true
        takeActionButton.centerXAnchor.constraint(equalTo: gameStatus.centerXAnchor).isActive = true
        takeActionButton.heightAnchor.constraint(equalTo: gameStatus.heightAnchor, multiplier: 0.5).isActive = true
        takeActionButton.widthAnchor.constraint(equalTo: gameStatus.widthAnchor).isActive = true
        takeActionButton.backgroundColor = .cyan
        //TODO: Title for button needs to show
        takeActionButton.setTitle("tap", for: .normal)
        takeActionButton.addTarget(self, action: #selector(takeAction), for: .touchUpInside)
        
        addDieOrDrinkView.topAnchor.constraint(equalTo: takeActionButton.bottomAnchor).isActive = true
        addDieOrDrinkView.centerXAnchor.constraint(equalTo: takeActionButton.centerXAnchor).isActive = true
        addDieOrDrinkView.widthAnchor.constraint(equalTo: gameStatus.widthAnchor).isActive = true
        addDieOrDrinkView.heightAnchor.constraint(equalTo: gameStatus.heightAnchor).isActive = true
        addDieOrDrinkView.addDieButton.addTarget(self, action: #selector(addDie), for: .touchUpInside)
        addDieOrDrinkView.drinkButton.addTarget(self, action: #selector(drink), for: .touchUpInside)
        
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backButton.setTitle("Back To Main Menu", for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
    }
}
