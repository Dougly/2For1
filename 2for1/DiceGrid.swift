//
//  DiceGrid.swift
//  2for1
//
//  Created by Douglas Galante on 2/2/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class DiceGrid: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var topLeftDieView: DieView!
    @IBOutlet weak var topCenterDieView: DieView!
    @IBOutlet weak var topRightDieView: DieView!
    
    @IBOutlet weak var centerLeftDIeView: DieView!
    @IBOutlet weak var centerDIeView: DieView!
    @IBOutlet weak var centerRightDieView: DieView!
    
    @IBOutlet weak var bottomLeftDieView: DieView!
    @IBOutlet weak var bottomCenterDieView: DieView!
    @IBOutlet weak var bottomRightDieView: DieView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DiceGrid", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }

}
