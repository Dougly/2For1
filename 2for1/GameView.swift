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
    @IBOutlet weak var banner: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    
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
        banner.layer.cornerRadius = banner.frame.height / 2
        circleView.layer.cornerRadius = circleView.frame.height / 2
    }
}

