//
//  CustomPlayerCell.swift
//  2for1
//
//  Created by Douglas Galante on 1/6/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class CustomPlayerCell: UICollectionViewCell {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CustomPlayerCell", owner: self, options: nil)
        contentView.addSubview(view)
        contentView.constrain(view)
    }
    
}
