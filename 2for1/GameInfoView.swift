//
//  GameInfoView.swift
//  2for1
//
//  Created by Douglas Galante on 12/24/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

class GameInfoView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("GameInfoView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
        contentView.backgroundColor = .gray
        topLabel.textColor = .white
        middleLabel.textColor = .white
        bottomLabel.textColor = .white
    }
    
}
