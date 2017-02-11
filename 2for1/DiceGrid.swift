//
//  DiceGrid.swift
//  2for1
//
//  Created by Douglas Galante on 2/2/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class DiceGrid: UIView {

    var diceArray: [DieView] = []
    var visibleDice: [DieView] = []
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var topLeftDieView: DieView!
    @IBOutlet weak var topCenterDieView: DieView!
    @IBOutlet weak var topRightDieView: DieView!
    
    @IBOutlet weak var centerLeftDieView: DieView!
    @IBOutlet weak var centerDieView: DieView!
    @IBOutlet weak var centerRightDieView: DieView!
    
    @IBOutlet weak var bottomLeftDieView: DieView!
    @IBOutlet weak var bottomCenterDieView: DieView!
    @IBOutlet weak var bottomRightDieView: DieView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        Bundle.main.loadNibNamed("DiceGrid", owner: self, options: nil)
        self.addSubview(contentView)
        self.constrain(contentView)
        addDieViewsToDiceArray()
        for (index, die) in diceArray.enumerated() {
            if index != 4 {
                die.isHidden = true
            } else {
                visibleDice.append(die)
            }
            die.tag = index
        }
    }
    
    
    func addDieViewsToDiceArray() {
        diceArray.append(topLeftDieView)
        diceArray.append(topCenterDieView)
        diceArray.append(topRightDieView)
        diceArray.append(centerLeftDieView)
        diceArray.append(centerDieView)
        diceArray.append(centerRightDieView)
        diceArray.append(bottomLeftDieView)
        diceArray.append(bottomCenterDieView)
        diceArray.append(bottomRightDieView)
    }
    
    
    func displayNumberOfDice(number: Int) {
        switch number {
        case 1: displayDiceIncluding(indexes: [4])
        case 2: displayDiceIncluding(indexes: [3, 5])
        case 3: displayDiceIncluding(indexes: [0, 4, 8])
        case 4: displayDiceIncluding(indexes: [1, 3, 5, 7])
        case 5: displayDiceIncluding(indexes: [0, 2, 4, 6, 8])
        case 6: displayDiceIncluding(indexes: [0, 2, 3, 5, 6, 8])
        case 7: displayDiceIncluding(indexes: [0, 2, 3, 4, 5, 6, 8])
        case 8: displayDiceIncluding(indexes: [0, 1, 2, 3, 4, 5, 6, 7])
        case 9: displayDiceIncluding(indexes: [0, 1, 2, 3, 4, 5, 6, 7, 8])
        default: break
        }
    }
    
    
    private func displayDiceIncluding(indexes: [Int]) {
        visibleDice = []
        for die in diceArray {
            for i in indexes {
                if die.tag == i {
                    die.isHidden = false
                    visibleDice.append(die)
                    break
                } else {
                    die.isHidden = true
                }
            }
        }
    }
    
    
    func updateDiceImages(dice: [Die]) {
        for (index, die) in visibleDice.enumerated() {
            if !die.isHidden {
                die.display(dice: dice[index].value)
            }
        }
    }
    

}



extension DiceGrid {
    
    func animateDice(in directon: UISwipeGestureRecognizerDirection, completion: @escaping (Bool) -> ()) {
        var constantMultiplier: CGFloat = 1
        var useTopConstraint = true
        let distance = contentView.frame.height / 2
        
        switch directon {
        case UISwipeGestureRecognizerDirection.up:
            constantMultiplier = -1
        case UISwipeGestureRecognizerDirection.right:
            useTopConstraint = false
        case UISwipeGestureRecognizerDirection.left:
            useTopConstraint = false
            constantMultiplier = -1
        default:
            break
        }
        
        for die in visibleDice {
            if die.dieImageView.image == #imageLiteral(resourceName: "die_0") {
                UIView.animateKeyframes(withDuration: 0.65, delay: 0, options: [], animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                        self.adjustConstraints(with: die, usingTopConstraint: useTopConstraint, distance: (distance * constantMultiplier), multiplier: 0.5)
                        self.layoutIfNeeded()
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2, animations: {
                        self.adjustConstraints(with: die, usingTopConstraint: useTopConstraint, distance: (distance * constantMultiplier), multiplier: -0.5)
                        self.layoutIfNeeded()
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.15, animations: {
                        self.adjustConstraints(with: die, usingTopConstraint: useTopConstraint, distance: (distance * constantMultiplier), multiplier: 0.25)
                        self.layoutIfNeeded()
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.1, animations: {
                        self.adjustConstraints(with: die, usingTopConstraint: useTopConstraint, distance: (distance * constantMultiplier), multiplier: -0.125)
                        self.layoutIfNeeded()
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.1, animations: {
                        self.adjustConstraints(with: die, usingTopConstraint: useTopConstraint, distance: (distance * constantMultiplier), multiplier: 0)
                        self.layoutIfNeeded()
                    })
                }, completion: { (success) in
                    completion(true)
                })
            }
        }
    }
    
    
    func adjustConstraints(with die: DieView, usingTopConstraint: Bool, distance: CGFloat, multiplier: CGFloat) {
        if usingTopConstraint {
            die.topConstraint.constant = distance * multiplier
        } else {
            die.leadingConstraint.constant = distance * multiplier
        }
    }
    
    
}











