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
    
    
    func setCornerRadius(with size: CGFloat) {
        let cornerRadius = size / 2
        middleDotView.layer.cornerRadius = cornerRadius
        leftDotView.layer.cornerRadius = cornerRadius
        rightDotView.layer.cornerRadius = cornerRadius
    }
    
    
    func setInitialConstraints(widthOfView: CGFloat, widthOfDot: CGFloat) {
        let distance = (widthOfView / 2) - (widthOfDot / 2)
        self.leftDotLeadingConstraint.constant = distance * -1
        self.rightDotTrailingConstraint.constant = distance
    }
    
    
    func expandDots() {
        let distance = (contentView.frame.width / 2) - (middleDotView.frame.width / 2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.leftDotLeadingConstraint.constant = distance * -1
            self.rightDotTrailingConstraint.constant = distance
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func collapseDots() {
        UIView.animate(withDuration: 0.2) {
            self.leftDotLeadingConstraint.constant = 0
            self.rightDotTrailingConstraint.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    
}
