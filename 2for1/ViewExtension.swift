//
//  ViewExtension.swift
//  2for1
//
//  Created by Douglas Galante on 12/24/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

extension UIView {
   
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func constrain(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    class func applyGradient(to view: UIView, topColor: UIColor, bottomColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.bounds = view.bounds
        gradient.frame = view.bounds
        gradient.colors = [topColor.cgColor , bottomColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }

}

