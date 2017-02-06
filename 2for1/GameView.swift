//
//  GameView.swift
//  2for1
//
//  Created by Douglas Galante on 1/19/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleShadow: UIView!
    @IBOutlet weak var diceGrid: DiceGrid!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("GameView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }
    
    func setCornerRadius(with size: CGFloat) {
        let constraintMultiplier: CGFloat = 0.9
        let cornerRadius = (size * constraintMultiplier) / 2
        circleView.layer.cornerRadius = cornerRadius
        circleShadow.layer.cornerRadius = cornerRadius
    }
    
    func update(die dice: [Die]) {
        for die in dice {
            let dieView = DieView()
            dieView.display(dice: die.value)
            //dieView.heightAnchor.constraint(equalTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>)
            //diceStackView.addArrangedSubview(dieView)
        }
    }
}

