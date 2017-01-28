//
//  DiceView.swift
//  2for1
//
//  Created by Douglas Galante on 1/28/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class DiceView: UIView {
    
    @IBOutlet var contentView: UIView!
    var dice: [UIImage] = [#imageLiteral(resourceName: "die_0"), #imageLiteral(resourceName: "die_1"), #imageLiteral(resourceName: "die_2"), #imageLiteral(resourceName: "die_3"), #imageLiteral(resourceName: "die_4"), #imageLiteral(resourceName: "die_5"), #imageLiteral(resourceName: "die_6")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DiceView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }
    
    func display(dice number: Int) {
        
    }
}
