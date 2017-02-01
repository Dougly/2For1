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
    @IBOutlet weak var diceStackView: UIStackView!
    @IBOutlet weak var circleShadow: UIView!
    
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
    
    func addCornerRadius() {
        circleView.layer.cornerRadius = circleView.frame.height / 2
        circleShadow.layer.cornerRadius = circleView.frame.height / 2
    }
    
    func update(die dice: [Die]) {
        for die in dice {
            let dieView = DieView()
            dieView.display(dice: die.value)
            diceStackView.addArrangedSubview(dieView)
        }
    }
}

