//
//  ViewController.swift
//  2for1
//
//  Created by Douglas Galante on 12/24/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

//extension NSObject: GameDelegate {
//    func updateGameBoard(with game: Game) {
//        print("testing delegate data binding")
//        switch game.action {
//        case .startGame: break
//        case .roll: break
//        case .passDice: break
//        case .rollAddedDie: break
//        case .drink: break
//        }
//    }
//}


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
    @IBOutlet weak var nextPlayerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var addDieOrDrinkLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var gameCoverView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewsCircles()
        applyTapGestures()
        addGradients()
        menuView.setShadowColor(with: .themeDarkestGreen)
        game.delegate = self
        game.player = game.players[0]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        gameView.update(die: game.dice)
        animateNextPlayerView()
        game.instructions = "\(game.players[0].tag!) starts the game"
        updateGameStatus()
    }
    
    
    func applyTapGestures() {
        for (index, menuItem) in menuView.views.enumerated() {
            switch index {
            case 0:
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(openCloseMenuTapped))
                menuItem.addGestureRecognizer(tapGR)
            case 1:
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(animateNextPlayerView))
                menuItem.addGestureRecognizer(tapGR)
            case 2:
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(animateAddDieOrDrinkView))
                menuItem.addGestureRecognizer(tapGR)
            case 3:
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
                menuItem.addGestureRecognizer(tapGR)
            default:
                break
            }
        }
        
        let swipeUpGR = UISwipeGestureRecognizer(target: self, action: #selector(takeAction))
        let swipeDownGR = UISwipeGestureRecognizer(target: self, action: #selector(takeAction))
        swipeUpGR.direction = .up
        swipeDownGR.direction = .down
        gameView.circleView.addGestureRecognizer(swipeUpGR)
        gameView.circleView.addGestureRecognizer(swipeDownGR)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(nextPlayerConfirmed))
        nextPlayerView.okView.addGestureRecognizer(tapGR)
        
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(animateAddDieOrDrinkView))
        addDieOrDrinkView.addDieView.addGestureRecognizer(tapGR2)
        
//        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(takeAction))
//        gameView.circleView.addGestureRecognizer(tapGR3)
        
        
    }
    
    func nextPlayerConfirmed() {
        animateNextPlayerView()
        game.instructions = "\(game.player!.tag!)'s roll"
        updateGameStatus()
    }
    
    func openCloseMenuTapped(_ sender: UIGestureRecognizer) {
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
        gameCoverView.layer.cornerRadius = (screenWidth * 0.9) / 2 //based on constraint multipliers
        gameView.setCornerRadius(with: screenWidth)
        menuView.setCornerRadius(with: screenHeight * 0.1) //based on constraint multipliers
        addDieOrDrinkView.setCornerRadius(with: screenWidth * 0.3) //based on constraint multipliers
        nextPlayerView.setCornerRadius(with: screenWidth * 0.6) //based on constraint multipliers
    }
    
}


extension GameViewController: GameDelegate {
    
    func updateGameBoard(with game: Game) {
        print("testing delegate data binding")
        switch game.action {
        case .startGame: break
        case .roll: break
        case .passDice: passedDice()
        case .rollAddedDie: break
        case .drink: break
        }
    }
    
    func passedDice() {
        animateNextPlayerView()
        game.instructions = "\(game.player!.tag!)'s turn"
    }
}

//Mark: Button Actions
extension GameViewController {
    
    func takeAction() {
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
            //instructionsView.instructionsLabel.text = turnPlayerDrinksString
        }
        var rollsString = "DICE:"
        _ = "  SCORE: \(game.score)"
        for die in game.dice {
            rollsString.append(" \(die.value)")
        }
//        gameStatus.middleLabel.text = rollsString + scoreString
        instructionsView.instructionsLabel.text = game.instructions
    }
}

//MARK: Animations

extension GameViewController {
    
    func animateAddDieOrDrinkView() {
        let distance = (screenWidth / 2) + (addDieOrDrinkView.frame.width / 2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.addDieOrDrinkLeadingConstraint.constant += distance * -1
            if self.addDieOrDrinkLeadingConstraint.constant == distance * -1 {
                self.gameCoverView.alpha = 0.5
            } else {
                self.gameCoverView.alpha = 0.0
            }
            self.view.layoutIfNeeded()
        }, completion: { success in
            if self.addDieOrDrinkLeadingConstraint.constant <= distance * -2 {
                self.addDieOrDrinkLeadingConstraint.constant = 0
            }
        })
    }
    
    func animateNextPlayerView() {
        let distance = (screenWidth / 2) + (nextPlayerView.frame.width / 2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.nextPlayerViewLeadingConstraint.constant += distance * -1
            if self.nextPlayerViewLeadingConstraint.constant == distance * -1 {
                self.gameCoverView.alpha = 0.5
            } else {
                self.gameCoverView.alpha = 0.0
            }
            self.view.layoutIfNeeded()
        }, completion: { success in
            if self.nextPlayerViewLeadingConstraint.constant <= distance * -2 {
                self.nextPlayerViewLeadingConstraint.constant = 0
            }
        })
    
    }
    
  
    
    
}









