//
//  CustomCollectionView.swift
//  2for1
//
//  Created by Douglas Galante on 1/20/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class PlayerCollectionView: UIView {
    
    
    @IBOutlet var collectionView: UICollectionView!
    let cell = CustomPlayerCell()
    
    let store = DataStore.sharedInstance
    
    let screenWidth = UIScreen.main.bounds.width
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var numberOfCellsPerRow: CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("PlayerCollectionView", owner: self, options: nil)
        self.addSubview(collectionView)
        self.constrain(collectionView)
        
        
        
        collectionView.register(CustomPlayerCell.self, forCellWithReuseIdentifier: "playerCell")
        //collectionView.cell
        //configureLayout()
        
    }
}

extension PlayerCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.players.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as! CustomPlayerCell
        let player = store.players[indexPath.row]
        cell.tagLabel.text = player.tag
        if cell.isSelected {
            cell.pictureImageView.image = #imageLiteral(resourceName: "childCare")
        } else {
            cell.pictureImageView.image = #imageLiteral(resourceName: "slime")
        }
        return cell
    }
    
}

extension PlayerCollectionView: UICollectionViewDelegateFlowLayout {
    
    func configureLayout() {
        let desiredSpacing: CGFloat = 5
        let itemWidth = (screenWidth / numberOfCellsPerRow) - (desiredSpacing + 2)
        let itemHeight = itemWidth * 1.25
        spacing = desiredSpacing
        sectionInsets = UIEdgeInsets(top: spacing * 2, left: spacing, bottom: spacing, right: spacing)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
