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
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var menuView: MenuView!
    @IBOutlet weak var gameView: GameView!
    @IBOutlet weak var instructionsView: InstructionsView!
    @IBOutlet weak var scoreView: ScoreView!
    @IBOutlet weak var addDieOrDrinkView: AddDieOrDrinkView!
    @IBOutlet weak var nextPlayerView: NextPlayerView!
    
    //Old UI Elements
    //var gameStatus: GameInfoView = GameInfoView()
    //let takeActionButton = UIButton()
    //let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewsCircles()
        applyTapGestures()
        addGradients()
        menuView.setShadowColor(with: .themeDarkestGreen)
        
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func applyTapGestures() {
        for (index, menuItem) in menuView.views.enumerated() {
            if index != menuView.views.count - 1 {
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(menuItemTapped))
                menuItem.addGestureRecognizer(tapGR)
            } else {
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
                menuItem.addGestureRecognizer(tapGR)
            }
        }
    }
    
    func menuItemTapped(_ sender: UIGestureRecognizer) {
        if menuView.isCollapsed == true {
            menuView.expandMenu()
        } else {
            menuView.collapseMenu(withDelay: 0)
        }
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func addGradients() {
        UIView.applyGradient(to: self.view, topColor: .themeMediumGreen, bottomColor: .themeGreen)
        UIView.applyGradient(to: menuView.contentView, topColor: .themeMediumGreen, bottomColor: .themeDarkestGreen)

    }
    
    func makeViewsCircles() {
        gameView.setCornerRadius(with: screenWidth)
        menuView.setCornerRadius(with: screenHeight * 0.1) //based on constraint multipliers
        addDieOrDrinkView.setCornerRadius(with: screenWidth * 0.3) //based on constraint multipliers
        nextPlayerView.setCornerRadius(with: screenWidth * 0.6) //based on constraint multipliers
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
            _ = "TURN: \(game.turn)  PLAYER: \(player.tag!)   DRINKS: \(game.drinks)"
            //gameStatus.topLabel.text = turnPlayerDrinksString
        }
        var rollsString = "DICE:"
        _ = "  SCORE: \(game.score)"
        for die in game.dice {
            rollsString.append(" \(die.value)")
        }
//        gameStatus.middleLabel.text = rollsString + scoreString
//        gameStatus.bottomLabel.text = game.instructions
    }
}

