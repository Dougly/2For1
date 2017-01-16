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
    var selectedIndexPaths: [IndexPath] = []
    let screenWidth = UIScreen.main.bounds.width
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var numberOfCellsPerRow: CGFloat = 3
    
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var startGameButton: UIButton!
    
    //menu
    @IBOutlet weak var menuViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var gameInfoLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var deletePlayersLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var addPlayerLeadingConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var openCloseMenuView: UIView!
    @IBOutlet weak var gameInfoView: UIView!
    @IBOutlet weak var deletePlayerView: UIView!
    @IBOutlet weak var addPlayerView: UIView!
    
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        addGestureRecognizersToViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        resetViewConroller()
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
            menuViewBottomConstraint.constant = 0
        }
    }
}


//MARK: Helper Methods
extension SetupViewController  {
    
    func resetViewConroller() {
        store.players.sort { $0.tag! < $1.tag! }
        playerCollectionView.reloadData()
        menuViewBottomConstraint.constant = 0
        selectedIndexPaths = []
        for player in store.players {
            player.selected = false
        }
    }
    
    func deleteSelectedPlayers(_ sender: UIView) {
        for ip in selectedIndexPaths {
            let playerData = self.store.players[ip.row]
            store.players.remove(at: ip.row)
            self.store.persistentContainer.viewContext.delete(playerData)
        }
        self.store.saveContext()
        hideStartGameButton()
        playerCollectionView.performBatchUpdates ({
            for ip in self.selectedIndexPaths {
                self.playerCollectionView.deleteItems(at: [ip])
            }
        }, completion: { (success) in
            self.selectedIndexPaths = []
        })
    }

    
    func makeViewsCircles() {
        openCloseMenuView.layer.cornerRadius = openCloseMenuView.frame.height / 2
    }
    
    func addGestureRecognizersToViews() {
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(tappedMenuOption))
        openCloseMenuView.addGestureRecognizer(gr)
        
    }
    
    func tappedMenuOption(_ sender: UIView) {
        if gameInfoLeadingConstraint.constant > 0 {
            collapseMenu()
        } else {
            expandMenu()
        }
    }
    
    
    
    
}

//MARK: Animations
extension SetupViewController {
    
    func hideStartGameButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
            self.menuViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showStartGameButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
            self.menuViewBottomConstraint.constant = self.startGameButton.frame.height * -1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func expandMenu() {
        let width = openCloseMenuView.frame.width + (openCloseMenuView.frame.width / 3)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.gameInfoLeadingConstraint.constant = width
            self.deletePlayersLeadingConstraint.constant = width * 2
            self.addPlayerLeadingConstraint.constant = width * 3
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func collapseMenu() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.gameInfoLeadingConstraint.constant = 0
            self.deletePlayersLeadingConstraint.constant = 0
            self.addPlayerLeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
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
            selectedIndexPaths.append(indexPath)
        } else {
            cell.pictureImageView.image = #imageLiteral(resourceName: "slime")
            store.players[indexPath.item].selected = false
            for (index, ip) in selectedIndexPaths.enumerated() {
                if indexPath == ip {
                    selectedIndexPaths.remove(at: index)
                }
            }
        }
        selectedIndexPaths.sort { $0.row > $1.row }
        
        if selectedIndexPaths.count >= 2 && menuViewBottomConstraint.constant == 0 {
            showStartGameButton()
        } else if selectedIndexPaths.count < 2 {
            hideStartGameButton()
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

