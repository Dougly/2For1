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
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        gameView.update(die: game.dice)
        self.animate(view: nextPlayerView, constraint: nextPlayerViewLeadingConstraint)
        game.instructions = "\(game.players[0].tag!) starts the game"
        updateGameStatus()
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
  
    
    func rolled() {
        if let results = game.roll() {
            if results.1 == true {
                //lose
            } else if results.0 == true {
                self.rolledOver()
            } else {
                self.animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint)
            }
        }
        updateGameStatus()
    }
    
    func addDie() {
        game.addDie()
        self.animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint)
        updateGameStatus()
    }
    
    func drink() {
        game.drink()
        animate(view: drinkView, constraint: drinkViewLeadingConstraint)
        updateGameStatus()
    }

    
    
    
    func rolledOver() {
        animate(view: rolledHighEnoughView, constraint: rolledHighEnoughLeadingConstraint)
        game.instructions = "you rolled a \(game.playerRoll)"
        updateGameStatus()
    }
    
    func rolledUnder() {
        animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint)
        game.instructions = "you rolled too low"
    }
}


//Mark: Button Actions
extension GameViewController {
    
    func rolledHighEnoughTapped() {
        animate(view: rolledHighEnoughView, constraint: rolledHighEnoughLeadingConstraint)
        game.instructions = "\(game.player!.tag!)'s turn!"
        updateGameStatus()
    }
    
    func nextPlayerConfirmed() {
        game.passDice()
        animate(view: nextPlayerView, constraint: nextPlayerViewLeadingConstraint)
        game.instructions = "\(game.player!.tag!)'s roll"
        updateGameStatus()
    }
    
    func diceSwiped() {
        switch game.action {
        case .roll: rolled()
        case .rollAddedDie: game.rollAddedDie()
        case .passDice: game.passDice()
        case .drink: drink()
        default:
            break
        }
        updateGameStatus()
    }
    
    
    
    
    func updateGameStatus() {
        print("\(game.action)")
        instructionsView.instructionsLabel.text = game.instructions
        scoreView.scoreLabel.text = String(game.score)
        scoreView.drinksLabel.text = String(game.drinks)
    }
}

//MARK: Animations

extension GameViewController {
    

    func animate(view: UIView, constraint: NSLayoutConstraint) {
        let distance = (screenWidth / 2) + (view.frame.width / 2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            constraint.constant += distance * -1
            if constraint.constant == distance * -1 {
                self.gameCoverView.isUserInteractionEnabled = false
                self.gameCoverView.alpha = 0.5
            } else {
                self.gameCoverView.isUserInteractionEnabled = true
                self.gameCoverView.alpha = 0.0
            }
            self.view.layoutIfNeeded()
        }, completion: { success in
            if constraint.constant <= distance * -2 {
                constraint.constant = 0
            }
        })
    }
    
    
}

//    func animateAddDieOrDrinkView() {
//        let distance = (screenWidth / 2) + (addDieOrDrinkView.frame.width / 2)
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
//            self.addDieOrDrinkLeadingConstraint.constant += distance * -1
//            if self.addDieOrDrinkLeadingConstraint.constant == distance * -1 {
//                self.gameCoverView.alpha = 0.5
//            } else {
//                self.gameCoverView.alpha = 0.0
//            }
//            self.view.layoutIfNeeded()
//        }, completion: { success in
//            if self.addDieOrDrinkLeadingConstraint.constant <= distance * -2 {
//                self.addDieOrDrinkLeadingConstraint.constant = 0
//            }
//        })
//    }
//
//    func animateNextPlayerView() {
//        let distance = (screenWidth / 2) + (nextPlayerView.frame.width / 2)
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
//            self.nextPlayerViewLeadingConstraint.constant += distance * -1
//            if self.nextPlayerViewLeadingConstraint.constant == distance * -1 {
//                self.gameCoverView.alpha = 0.5
//            } else {
//                self.gameCoverView.alpha = 0.0
//            }
//            self.view.layoutIfNeeded()
//        }, completion: { success in
//            if self.nextPlayerViewLeadingConstraint.constant <= distance * -2 {
//                self.nextPlayerViewLeadingConstraint.constant = 0
//            }
//        })
//    }
//
//    func animateRolledHighEnoughView() {
//        let distance = (screenWidth / 2) + (rolledHighEnoughView.frame.width / 2)
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
//            self.rolledHighEnoughLeadingConstraint.constant += distance * -1
//            if self.rolledHighEnoughLeadingConstraint.constant == distance * -1 {
//                self.gameCoverView.isUserInteractionEnabled = false
//            } else {
//                self.gameCoverView.isUserInteractionEnabled = true
//            }
//            self.view.layoutIfNeeded()
//        }, completion: { success in
//            if self.rolledHighEnoughLeadingConstraint.constant <= distance * -2 {
//                self.rolledHighEnoughLeadingConstraint.constant = 0
//            }
//        })
//    }
//
//    func animateDrinkView() {
//        let distance = (screenWidth / 2) + (drinkView.frame.width / 2)
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
//            self.drinkViewLeadingConstraint.constant += distance * -1
//            if self.drinkViewLeadingConstraint.constant == distance * -1 {
//                self.gameCoverView.isUserInteractionEnabled = false
//
//            } else {
//                self.gameCoverView.isUserInteractionEnabled = true
//            }
//            self.view.layoutIfNeeded()
//        }, completion: { success in
//            if self.drinkViewLeadingConstraint.constant <= distance * -2 {
//                self.drinkViewLeadingConstraint.constant = 0
//            }
//        })
//    }










