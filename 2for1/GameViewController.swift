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
    @IBOutlet weak var rolledHighEnoughView: CheckMarkView!
    @IBOutlet weak var rolledHighEnoughLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var drinkView: CheckMarkView!
    @IBOutlet weak var drinkViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rollLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewsCircles()
        applyTapGestures()
        addGradients()
        menuView.setShadowColor(with: .themeDarkestGreen)
        game.player = game.players[0]
        game.instructions = "\(game.players[0].tag!) starts the game"
        updateInstructions()
        
        menuView.secondOptionImageView.image = #imageLiteral(resourceName: "refresh")
        menuView.thirdOptionImageView.image = #imageLiteral(resourceName: "delete")
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
        
        let tapGR5 = UITapGestureRecognizer(target: self, action: #selector(resetGame))
        menuView.secondOptionView.addGestureRecognizer(tapGR5)

        //let tapGR6 = UITapGestureRecognizer(target: self, action: #selector(animate))

        let tapGR7 = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        menuView.thirdOptionView.addGestureRecognizer(tapGR7)
        
        let tapGR8 = UITapGestureRecognizer(target: self, action: #selector(resetGame))
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
        rolledHighEnoughView.setCornerRadius(with: screenWidth * 0.2)
        rolledHighEnoughView.restartLabel.isHidden = true
        drinkView.setCornerRadius(with: screenWidth * 0.2)
        drinkView.checkImageView.isHidden = true
        drinkView.checkBackgroundView.backgroundColor = UIColor.themeBlue
    }
    
}

//gesture actions
extension GameViewController {
  
    func diceSwiped() {
        switch game.action {
        case .roll: rolled()
        case .rollAddedDie: rollAddedDie()
        default: break
        }
    }
    
    func rolled() {
        let results = game.roll()
        gameView.diceGrid.updateDiceImages(dice: game.dice)
        if results.tiedRoll {
            tiedRoll()
        } else if results.wonRoll {
            animate(view: rolledHighEnoughView, constraint: rolledHighEnoughLeadingConstraint, coverGameView: false)
            game.instructions = "\(game.player!.tag!) rolled high enough!"
        } else {
            animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint, coverGameView: true)
            game.instructions = "\(game.player!.tag!) rolled too low"
        }
        updateInstructions()
    }
    
    func addDie() {
        game.addDie()
        gameView.diceGrid.displayNumberOfDice(number: game.dice.count)
        gameView.diceGrid.updateDiceImages(dice: game.dice)
        self.animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint, coverGameView: true)
        updateInstructions()
        updateScoreBoard()
    }
    
    func rollAddedDie() {
        let result = game.rollAddedDie()
        gameView.diceGrid.updateDiceImages(dice: game.dice)
        if result {
            animate(view: rolledHighEnoughView, constraint: rolledHighEnoughLeadingConstraint, coverGameView: false)
            game.instructions = "\(game.player!.tag!) rolled high enough!"
        } else {
            tiedRoll()
        }
        updateInstructions()
    
    }
    
    func rolledHighEnoughTapped() {
        animate(view: rolledHighEnoughView, constraint: rolledHighEnoughLeadingConstraint, coverGameView: false)
        animate(view: nextPlayerView, constraint: nextPlayerViewLeadingConstraint, coverGameView: true)
        game.passDice()
        gameView.diceGrid.displayNumberOfDice(number: game.dice.count)
        gameView.diceGrid.updateDiceImages(dice: game.dice)
        updateScoreBoard()
        updateInstructions()
    }
    
    func drink() {
        game.instructions = "\(game.player!.tag!) must drink \(game.drinks) drinks!!"
        animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint, coverGameView: true)
        animate(view: drinkView, constraint: drinkViewLeadingConstraint, coverGameView: false)
        updateInstructions()
    }
    
    func tiedRoll() {
        if game.playerRoll == game.score {
        game.instructions = "\(game.player!.tag!) tied the score and must drink \(game.drinks) drinks!"
        } else {
            game.instructions = "\(game.player!.tag!) rolled too lowed and must drink \(game.drinks) drinks!"
        }
        animate(view: drinkView, constraint: drinkViewLeadingConstraint, coverGameView: false)
    }
    
    func resetGame() {
        if drinkViewLeadingConstraint.constant < 0 {
            animate(view: drinkView, constraint: drinkViewLeadingConstraint, coverGameView: false)
        }
        if addDieOrDrinkLeadingConstraint.constant < 0 {
            animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint, coverGameView: true)
        }
        if rolledHighEnoughLeadingConstraint.constant < 0 {
            animate(view: rolledHighEnoughView, constraint: rolledHighEnoughLeadingConstraint, coverGameView: false)
        }
        
        game.resetGame()
        gameView.diceGrid.displayNumberOfDice(number: 1)
        gameView.diceGrid.updateDiceImages(dice: game.dice)
        
        if nextPlayerViewLeadingConstraint.constant == 0 {
            animate(view: nextPlayerView, constraint: nextPlayerViewLeadingConstraint, coverGameView: true)
        }
        updateScoreBoard()
        updateInstructions()
        
    }
    func rolledUnder() {
        animate(view: addDieOrDrinkView, constraint: addDieOrDrinkLeadingConstraint, coverGameView: true)
        game.instructions = "\(game.player!.tag!) rolled too low"
    }
}

//MARK: Gesture Helper Methods
extension GameViewController {
    
}

//Mark: Button Actions
extension GameViewController {
    
    
    
    func nextPlayerConfirmed() {
        animate(view: nextPlayerView, constraint: nextPlayerViewLeadingConstraint, coverGameView: true)
        game.instructions = "\(game.player!.tag!)'s roll"
        updateInstructions()
    }
    
    

    
    func updateInstructions() {
        instructionsView.instructionsLabel.text = game.instructions
        gameView.scoreLabel.text = String(game.playerRoll)
    }
    
    func updateScoreBoard() {
        if game.drinks == 1 {
            scoreView.drinksTextLabel.text = "drink"
        } else {
            scoreView.drinksTextLabel.text = "drinks"
        }
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
                self.gameView.isUserInteractionEnabled = false
            } else if !coverGameView {
                self.gameView.isUserInteractionEnabled = true
            }
        
            self.view.layoutIfNeeded()
        }, completion: { success in
            if constraint.constant <= distance * -2 {
                constraint.constant = 0
            }
        })
    }
    
}










