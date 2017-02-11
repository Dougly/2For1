//
//  InfoView.swift
//  2for1
//
//  Created by Douglas Galante on 2/8/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var firstInstructionLabel: UILabel!
    @IBOutlet weak var secondInstructionLabel: UILabel!
    @IBOutlet weak var thirdInstructionLabel: UILabel!
    @IBOutlet weak var rollsHigherDescriptionLabel: UILabel!
    @IBOutlet weak var rollsLowerDescriptionLabel: UILabel!
    @IBOutlet weak var tiesDescriptionLabel: UILabel!
    @IBOutlet weak var fourthInstructionLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
        setText()
    }
    
    
    func setText() {
        let firstInstruction = "A player starts the game by rolling a single die. This sets the initial score."
        let secondInstruction = "After rolling, the die is passed to the next player. When the die is passed to a new player the drink wager goes up by 1."
        let thirdInstruction = "The next player then roles the dice. There are three outcomes:"
        
        let one = "In the case of the player rolling higher than the score their roll becomes the new score to beat and they can pass the die on to the next player. Passing the die incrtements the drink wager by 1."
        let two = "In the case of the player rolling lower than the score the player has the option to drink the current number of drinks, or add an additional die and double the drinking wager. The player can only add one die during their turn and adds the single die roll onto their previous roll. If the player fails to roll higher than the current score with the additional die they must drink the now doubled number of drinks."
        let three = "If the player ties the current score it is an automatic loss and they must drink the current number of drinks."
        
        let fourthInstruction = "The game continues until a player drinks and restarts the game."
        firstInstructionLabel.text = firstInstruction
        secondInstructionLabel.text = secondInstruction
        thirdInstructionLabel.text = thirdInstruction
        rollsHigherDescriptionLabel.text = one
        rollsLowerDescriptionLabel.text = two
        tiesDescriptionLabel.text = three
        fourthInstructionLabel.text = fourthInstruction
    }
    
    
}
