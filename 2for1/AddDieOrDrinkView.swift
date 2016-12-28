//
//  AddDieOrDrink.swift
//  2for1
//
//  Created by Douglas Galante on 12/27/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

class AddDieOrDrinkView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var addDieButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("AddDieOrDrinkView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
        
    }
    
}
