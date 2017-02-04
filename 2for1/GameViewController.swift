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
    @IBOutlet weak var nextPlayerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var addDieOrDrinkLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var gameCoverView: UIView!
    @IBOutlet weak var rolledHighEnoughView: UIView!
    @IBOutlet weak var rolledHighEnoughLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var drinkView: UIView!
    @IBOutlet weak var drinkViewLeadingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewsCircles()
        applyTapGestures()
        addGradients()
        menuView.setShadowColor(with: .themeDarkestGreen)
        game.player = game.players[0]
        game.instructions = "\(game.players[0].tag!) starts the game"
        updateGameStatus()
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        //gameView.update(die: game.dice)
        animate(view: nextPlayerView, constraint: nextPlayerViewLeadingConstraint, coverGameView: true)
        
    }
    
    
    func applyTapGestures() {
        
        let swipeUpGR = UISwipeGestureRecognizer(target: self, action: #selector(diceSwiped))
        let swipeDownGR = UISwipeGestureRecognizer(target: self, action: #selector(diceSwiped))
        swipeUpGR.direction = .up
        swipeDownGR.direction = .down
        gameView.circleView.addGestureRecognizer(swipeUpGR)
        gameView.circleView.addGestureRecognizer(swipeDownGR)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(nextPlayerConfirmed))
        nextPlayerView.okView.addGestureRecognizer(tapGR)
        
        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(drink))
        addDieOrDrinkView.drinkView.addGestureRecognizer(tapGR1)
        
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(addDie))
        addDieOrDrinkView.addDieView.addGestureRecognizer(tapGR2)
        
        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(rolledHighEnoughTapped))
        rolledHighEnoughView.addGestureRecognizer(tapGR3)
        
        let tapGR4 = UITapGestureRecognizer(target: self, action: #selector(openCloseMenuTapped))
        menuView.openCloseMenuView.addGestureRecognizer(tapGR4)
        
        //let tapGR5 = UITapGestureRecognizer(target: self, action: #selector(animate))

        //let tapGR6 = UITapGestureRecognizer(target: self, action: #selector(animate))

        let tapGR7 = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        menuView.thirdOptionView.addGestureRecognizer(tapGR7)
        
        let tapGR8 = UITapGestureRecognizer(target: self, action: #selector(drink))
        drinkView.addGestureRecognizer(tapGR8)
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


extension GameViewController {
  
    func diceSwiped() {
        switch game.action {
        case .roll: rolled()
        case .rollAddedDie: rollAddedDie()
        case .passDice: game.passDice()
        case .drink: drink()
        default:
            break
        }
        print("score: \(game.score) drinks: \(game.drinks)")
    }
    
    func rolled() {
        if let results = game.roll() {
            
            if results.1 == true {
                drink()
            } else if results.0 == true {
                rolledOver()
            } else {
                animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint, coverGameView: true)
            }
        }
        updateGameStatus()
    }
    
    func addDie() {
        game.addDie()
        self.animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint, coverGameView: true)
        updateGameStatus()
    }
    
    func rollAddedDie() {
        let result = game.rollAddedDie()
        if result {
            rolledOver()
        } else {
            drink()
        }
        updateGameStatus()
    }
    
    func rolledHighEnoughTapped() {
        animate(view: rolledHighEnoughView, constraint: rolledHighEnoughLeadingConstraint, coverGameView: false)
        animate(view: nextPlayerView, constraint: nextPlayerViewLeadingConstraint, coverGameView: true)
        game.passDice()
        updateGameStatus()
    }
    
    func drink() {
        game.drink()
        animate(view: drinkView, constraint: drinkViewLeadingConstraint, coverGameView: false)
        updateGameStatus()
    }
    
    func resetGame() {
        game.resetGame()
        
    }
    
    func rolledOver() {
        animate(view: rolledHighEnoughView, constraint: rolledHighEnoughLeadingConstraint, coverGameView: false)
        game.instructions = "you rolled a \(game.playerRoll)"
        updateGameStatus()
    }
    
    func rolledUnder() {
        animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint, coverGameView: true)
        game.instructions = "you rolled too low"
    }
}


//Mark: Button Actions
extension GameViewController {
    
    
    
    func nextPlayerConfirmed() {
        animate(view: nextPlayerView, constraint: nextPlayerViewLeadingConstraint, coverGameView: true)
        game.instructions = "\(game.player!.tag!)'s roll"
        updateGameStatus()
    }
    
    

    
    func updateGameStatus() {
        print("Most Recent Action: \(game.action)")
        instructionsView.instructionsLabel.text = game.instructions
        scoreView.scoreLabel.text = String(game.score)
        scoreView.drinksLabel.text = String(game.drinks)
    }
}

//MARK: Animations

extension GameViewController {
    
    func animate(view: UIView, constraint: NSLayoutConstraint, coverGameView: Bool) {
        let distance = (screenWidth / 2) + (view.frame.width / 2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            
            constraint.constant += distance * -1
            
            if coverGameView && constraint.constant == distance * -1  {
                self.gameCoverView.alpha = 0.5
            } else if coverGameView {
                self.gameCoverView.alpha = 0.0
            }
            
            if !coverGameView && constraint.constant == distance * -1  {
                self.gameCoverView.isUserInteractionEnabled = false
            } else if !coverGameView {
                self.gameCoverView.isUserInteractionEnabled = true
            }
        
            self.view.layoutIfNeeded()
        }, completion: { success in
            if constraint.constant <= distance * -2 {
                constraint.constant = 0
            }
        })
    }
    
}










