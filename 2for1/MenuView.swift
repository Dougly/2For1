//
//  MenuView.swift
//  2for1
//
//  Created by Douglas Galante on 1/20/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var views: [UIView] = []
    var isCollapsed = true
    
    @IBOutlet weak var openCloseMenuView: UIView!
    @IBOutlet weak var openCloseMenuDotsView: DotsView!
    @IBOutlet weak var openCloseMenuCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstOptionView: UIView!
    @IBOutlet weak var firstOptionImageView: UIImageView!
    @IBOutlet weak var firstOptionLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var secondOptionView: UIView!
    @IBOutlet weak var secondOptionImageView: UIImageView!
    @IBOutlet weak var secondOptionLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var thirdOptionView: UIView!
    @IBOutlet weak var thirdOptionImageView: UIImageView!
    @IBOutlet weak var thirdOptionLeadingConstraint: NSLayoutConstraint!
    
    
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
    }
    
    func setCornerRadius() {
        let cornerRadius = openCloseMenuView.frame.height / 2
        openCloseMenuView.layer.cornerRadius = cornerRadius
        firstOptionView.layer.cornerRadius = cornerRadius
        secondOptionView.layer.cornerRadius = cornerRadius
        thirdOptionView.layer.cornerRadius = cornerRadius
        openCloseMenuDotsView.setCornerRadius()
        openCloseMenuDotsView.expandDots()
    }
    
    func set(images first: UIImage, second: UIImage, third: UIImage) {
        firstOptionImageView.image = first
        secondOptionImageView.image = second
        thirdOptionImageView.image = third
    }
    
    func expandMenu() {
        let width = openCloseMenuView.frame.width + (openCloseMenuView.frame.width / 3)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
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
        UIView.animate(withDuration: 0.2, delay: seconds, options: [.curveEaseIn], animations: {
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
