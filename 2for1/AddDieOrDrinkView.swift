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
    @IBOutlet weak var drinkView: UIView!
    @IBOutlet weak var addDieView: UIView!
    @IBOutlet weak var addDieViewShadow: UIView!
    @IBOutlet weak var drinkViewShadow: UIView!

    
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
    
    func setCornerRadius(with size: CGFloat) {
        let constraintMultiplier: CGFloat = 0.8
        let cornerRadius = (size * constraintMultiplier) / 2
        drinkView.layer.cornerRadius = cornerRadius
        drinkViewShadow.layer.cornerRadius = cornerRadius
        addDieView.layer.cornerRadius = cornerRadius
        addDieViewShadow.layer.cornerRadius = cornerRadius
    }
}
