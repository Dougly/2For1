//
//  CheckMarkView.swift
//  2for1
//
//  Created by Douglas Galante on 2/6/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class CheckMarkView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var checkBackgroundView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var restartLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CheckMarkView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }
    
    func setCornerRadius(with size: CGFloat) {
        let constraintMultiplier: CGFloat = 1
        let cornerRadius = (size * constraintMultiplier) / 2
        checkBackgroundView.layer.cornerRadius = cornerRadius
        checkImageView.layer.cornerRadius = cornerRadius
    }

}
