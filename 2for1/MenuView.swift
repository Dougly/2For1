//
//  MenuView.swift
//  2for1
//
//  Created by Douglas Galante on 1/20/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    var views: [UIView] = []
    var isCollapsed = true
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var openCloseMenuView: UIView!
    @IBOutlet weak var openCloseMenuDotsView: DotsView!
    @IBOutlet weak var openCloseMenuCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var openCloseMenuShadow: UIView!
    
    @IBOutlet weak var firstOptionView: UIView!
    @IBOutlet weak var firstOptionImageView: UIImageView!
    @IBOutlet weak var firstOptionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstOptionShadow: UIView!

    @IBOutlet weak var secondOptionView: UIView!
    @IBOutlet weak var secondOptionImageView: UIImageView!
    @IBOutlet weak var secondOptionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondOptionShadow: UIView!
    
    @IBOutlet weak var thirdOptionView: UIView!
    @IBOutlet weak var thirdOptionImageView: UIImageView!
    @IBOutlet weak var thirdOptionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdOptionShadow: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
        views.append(openCloseMenuView)
        views.append(firstOptionView)
        views.append(secondOptionView)
        views.append(thirdOptionView)
        for (index, view) in views.enumerated() {
            view.tag = index
        }
    }
    
    
    func setCornerRadius(with size: CGFloat) {
        let constraintMultiplier: CGFloat = 0.7
        let cornerRadius = (size * constraintMultiplier) / 2
        openCloseMenuView.layer.cornerRadius = cornerRadius
        firstOptionView.layer.cornerRadius = cornerRadius
        secondOptionView.layer.cornerRadius = cornerRadius
        thirdOptionView.layer.cornerRadius = cornerRadius
        thirdOptionShadow.layer.cornerRadius = cornerRadius
        secondOptionShadow.layer.cornerRadius = cornerRadius
        firstOptionShadow.layer.cornerRadius = cornerRadius
        openCloseMenuShadow.layer.cornerRadius = cornerRadius
        openCloseMenuDotsView.setCornerRadius(with: size * 0.1)
        openCloseMenuDotsView.setInitialConstraints(widthOfView: (size * constraintMultiplier) * 0.6, widthOfDot: (size * constraintMultiplier) * 0.1) //based on constraint multipliers
    }
    
        
    func set(images first: UIImage, second: UIImage, third: UIImage) {
        firstOptionImageView.image = first
        secondOptionImageView.image = second
        thirdOptionImageView.image = third
    }
    
    
    func setShadowColor(with color: UIColor) {
        thirdOptionShadow.backgroundColor = color
        secondOptionShadow.backgroundColor = color
        firstOptionShadow.backgroundColor = color
        openCloseMenuShadow.backgroundColor = color
    }
    
    
    func expandMenu() {
        let width = openCloseMenuView.frame.width + (openCloseMenuView.frame.width / 3)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.openCloseMenuCenterXConstraint.constant = width * -1.5
            self.firstOptionLeadingConstraint.constant = width
            self.secondOptionLeadingConstraint.constant = width * 2
            self.thirdOptionLeadingConstraint.constant = width * 3
            self.layoutIfNeeded()
        }, completion: { (success) in
            self.isCollapsed = false
        })
        openCloseMenuDotsView.collapseDots()
    }
    
    
    func collapseMenu(withDelay seconds: TimeInterval) {
        UIView.animate(withDuration: 0.2, delay: seconds, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.openCloseMenuCenterXConstraint.constant = 0
            self.firstOptionLeadingConstraint.constant = 0
            self.secondOptionLeadingConstraint.constant = 0
            self.thirdOptionLeadingConstraint.constant = 0
            self.layoutIfNeeded()
        }, completion: {(success) in
            self.openCloseMenuDotsView.expandDots()
            self.isCollapsed = true
        })
    }
    
    
}
