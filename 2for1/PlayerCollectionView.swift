//
//  PlayerCollectionViewDelegate.swift
//  2for1
//
//  Created by Douglas Galante on 1/21/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class PlayerCollectionView: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UpdateCollectionViewProtocol {
    
    let store = DataStore.sharedInstance
    var delegate: SetupViewController?
    let screenWidth = UIScreen.main.bounds.width
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var size: CGSize!
    var numberOfCellsPerRow: CGFloat = 3
    
    func configureLayout () {
        let desiredSpacing: CGFloat = 5
        let itemWidth = (screenWidth / numberOfCellsPerRow) - (desiredSpacing + 2)
        let itemHeight = itemWidth * 1.25
        spacing = desiredSpacing
        sectionInsets = UIEdgeInsets(top: spacing * 2, left: spacing, bottom: spacing, right: spacing)
        size = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func reloadCollectionView(withPlayer handle: String) {
        delegate?.reloadCollectionView(withPlayer: handle)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomPlayerCell
        guard let viewController = delegate else { return }
        
        if cell.pictureImageView.image == #imageLiteral(resourceName: "slime") {
            cell.pictureImageView.image = #imageLiteral(resourceName: "childCare")
            store.players[indexPath.item].isSelected = true
            viewController.selectedIndexPaths.append(indexPath)
        } else {
            cell.pictureImageView.image = #imageLiteral(resourceName: "slime")
            store.players[indexPath.item].isSelected = false
            for (index, ip) in viewController.selectedIndexPaths.enumerated() {
                if indexPath == ip {
                    viewController.selectedIndexPaths.remove(at: index)
                }
            }
        }
        
        viewController.selectedIndexPaths.sort { $0.row > $1.row }
        
        if viewController.selectedIndexPaths.count >= 2 && viewController.playerCollectionViewBottomConstraint.constant == 0 {
            viewController.showStartGameButton()
        } else if viewController.selectedIndexPaths.count < 2 {
            viewController.hideStartGameButton()
        }
    }

}
