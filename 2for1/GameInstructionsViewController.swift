//
//  GameInstructionsViewController.swift
//  2for1
//
//  Created by Douglas Galante on 2/8/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class GameInstructionsViewController: UIViewController {
    
    var delegate: BlurViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(closeVC))
        swipeGR.direction = .down
        self.view.addGestureRecognizer(swipeGR)
    }
    
    func closeVC() {
        self.dismiss(animated: true, completion: nil)
        delegate?.unBlurView()
    }
    

}
