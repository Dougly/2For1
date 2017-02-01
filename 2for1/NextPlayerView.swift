//
//  NextPlayerView.swift
//  2for1
//
//  Created by Douglas Galante on 2/1/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class NextPlayerView: UIView {
 
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var okView: UIView!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var okViewShadow: UIView!
    @IBOutlet weak var picImageViewShadow: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("NextPlayerView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }
    
    func setCornerRadius() {
        okView.layer.cornerRadius = okView.frame.height / 2
        picImageView.layer.cornerRadius = picImageView.frame.height / 2
        okViewShadow.layer.cornerRadius = okView.frame.height / 2
        picImageViewShadow.layer.cornerRadius = picImageView.frame.height / 2
    }
    
}
