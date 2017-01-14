//
//  SetupViewController.swift
//  2for1
//
//  Created by Douglas Galante on 1/5/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    var selectedPlayers: [IndexPath] = []
    let screenWidth = UIScreen.main.bounds.width
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var numberOfCellsPerRow: CGFloat = 3
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var playerCollectionViewBottomConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        store.players.sort { $0.tag! < $1.tag! }
        playerCollectionView.reloadData()
        playerCollectionViewBottomConstraint.constant = 0
        selectedPlayers = []
        for player in store.players {
            player.selected = false
        }
    }
    

    
    
    @IBAction func deletePlayer(_ sender: UIButton) {
        
        for ip in selectedPlayers {
            let playerData = self.store.players[ip.row]
            store.players.remove(at: ip.row)
            self.store.persistentContainer.viewContext.delete(playerData)
        }
        self.store.saveContext()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
            self.playerCollectionViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        playerCollectionView.performBatchUpdates ({
            for ip in self.selectedPlayers {
                self.playerCollectionView.deleteItems(at: [ip])
            }
        }, completion: { (success) in
            self.selectedPlayers = []
        })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            let destVC = segue.destination as! GameViewController
            var selectedPlayers: [Player] = []
            for player in store.players {
                if player.selected {
                    selectedPlayers.append(player)
                    player.selected = false
                }
            }
            destVC.game.players = selectedPlayers
            selectedPlayers = []
            playerCollectionViewBottomConstraint.constant = 0
        }
    }
}

//MARK: Collection View Setup
extension SetupViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomPlayerCell
        
        if cell.pictureImageView.image == #imageLiteral(resourceName: "slime") {
            cell.pictureImageView.image = #imageLiteral(resourceName: "childCare")
            store.players[indexPath.item].selected = true
            selectedPlayers.append(indexPath)
        } else {
            cell.pictureImageView.image = #imageLiteral(resourceName: "slime")
            store.players[indexPath.item].selected = false
            for (index, ip) in selectedPlayers.enumerated() {
                if indexPath == ip {
                    selectedPlayers.remove(at: index)
                }
            }
        }
        selectedPlayers.sort { $0.row > $1.row }
        
        if selectedPlayers.count >= 2 && playerCollectionViewBottomConstraint.constant == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
                self.playerCollectionViewBottomConstraint.constant = self.startGameButton.frame.height * -1
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else if selectedPlayers.count < 2 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
                self.playerCollectionViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

//MARK: Collection view flow Layout
extension SetupViewController: UICollectionViewDelegateFlowLayout {
    
    func configureLayout () {
        let desiredSpacing: CGFloat = 5
        let itemWidth = (screenWidth / numberOfCellsPerRow) - (desiredSpacing + 2)
        let itemHeight = itemWidth * 1.25
        spacing = desiredSpacing
        sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
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

