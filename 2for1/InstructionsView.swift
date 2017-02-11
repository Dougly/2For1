//
//  InstructionsView.swift
//  2for1
//
//  Created by Douglas Galante on 1/28/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class InstructionsView: UIView {
    
    @IBOutlet var contentView: UIView!
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
        Bundle.main.loadNibNamed("InstructionsView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }
    
    
    func updateInstructions(with string: String) {
        instructionsLabel.text = string
    }

    
}
