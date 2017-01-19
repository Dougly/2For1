//
//  DotsView.swift
//  2for1
//
//  Created by Douglas Galante on 1/17/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class DotsView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var middleDotView: UIView!
    @IBOutlet weak var leftDotView: UIView!
    @IBOutlet weak var rightDotView: UIView!
    @IBOutlet weak var leftDotLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightDotTrailingConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DotsView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }
    
    
    func makeDotsCircles() {
        let cornerRadius = middleDotView.frame.height / 2
        middleDotView.layer.cornerRadius = cornerRadius
        leftDotView.layer.cornerRadius = cornerRadius
        rightDotView.layer.cornerRadius = cornerRadius

    }
    
}
