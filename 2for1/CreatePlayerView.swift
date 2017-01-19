//
//  CreatePlayerView.swift
//  2for1
//
//  Created by Douglas Galante on 1/18/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class CreatePlayerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var handleTextField: UITextField!
    @IBOutlet weak var playerPictureImageView: UIImageView!
    @IBOutlet weak var placeholderView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CreatePlayerView", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
    }
    
}
