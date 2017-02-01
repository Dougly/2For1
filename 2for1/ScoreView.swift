//
//  ScoreView.swift
//  2for1
//
//  Created by Douglas Galante on 1/28/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var drinksLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ScoreView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }
    
    func updateLabels(score: Int, drinks: Int) {
        scoreLabel.text = "\(score)"
        drinksLabel.text = "\(drinks)"
    }
}
