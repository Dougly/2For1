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
    override var prefersStatusBarHidden: Bool { return true }
    
    @IBOutlet weak var collectionViewContainerView: PlayerCollectionView!
    var playerCV: PlayerCV!
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var menuView: MenuView!
    @IBOutlet weak var collectionViewContainerBottomConstraint: NSLayoutConstraint!
    
    //Collection View Flow Layout Variables
//    let screenWidth = UIScreen.main.bounds.width
//    var spacing: CGFloat!
//    var sectionInsets: UIEdgeInsets!
//    var itemSize: CGSize!
//    var numberOfCellsPerRow: CGFloat = 3
    
    //var playerCollectionView: PlayerCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureLayout()
        applyTapGestures()
        
        collectionView = collectionViewContainerView.collectionView
        collectionViewContainerView.collectionView.delegate = self
        collectionViewContainerView.collectionView.dataSource = collectionViewContainerView
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetViewConroller()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        menuView.setCornerRadius()
        menuView.openCloseMenuDotsView.expandDots()
        collectionViewContainerView.configureLayout()
        collectionView.reloadData()
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
            collectionViewContainerBottomConstraint.constant = 0
        }
        
        if segue.identifier == "addPlayer" {
            let destVC = segue.destination as! CreatePlayerViewController
            destVC.delegate = self
        }
    }
}


//MARK: Helper Methods
extension SetupViewController: UpdateCollectionViewProtocol {
    
    func resetViewConroller() {
        store.players.sort { $0.tag! < $1.tag! }
        collectionView.reloadData()
        collectionViewContainerBottomConstraint.constant = 0
        selectedIndexPaths = []
        for player in store.players {
            player.selected = false
        }
    }
    
    func customReload(withPlayer handle: String) {
        store.players.sort { $0.tag! < $1.tag! }
        for (index, player) in store.players.enumerated() {
            if let tag = player.tag {
                if tag == handle {
                    let indexPath = IndexPath(item: index, section: 0)
                    collectionView.performBatchUpdates({
                        self.collectionView.insertItems(at: [indexPath])
                    }, completion: nil)
                }
            }
        }
    }

    func applyTapGestures() {
        for menuItem in menuView.views {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(menuItemTapped))
            menuItem.addGestureRecognizer(tapGR)
            
        }
    }
    
    func menuItemTapped(_ sender: UITapGestureRecognizer) {
        if let selectedView = sender.view {
            switch selectedView.tag {
            case 0: tappedMenuOption()
            case 1: tappedShowGameInfoView()
            case 2: tappedRemovePlayers()
            case 3: tappedAddPlayer()
            default: break
            }
        }
    }
    
    func tappedMenuOption() {
        menuView.isCollapsed ? menuView.expandMenu() : menuView.collapseMenu(withDelay: 0)
    }
    
    func tappedAddPlayer() {
        performSegue(withIdentifier: "addPlayer", sender: self)
        menuView.collapseMenu(withDelay: 0.5)
    }
    
    func tappedRemovePlayers() {
        for ip in selectedIndexPaths {
            let playerData = self.store.players[ip.row]
            store.players.remove(at: ip.row)
            self.store.persistentContainer.viewContext.delete(playerData)
        }
        self.store.saveContext()
        hideStartGameButton()
        collectionView.performBatchUpdates ({
            for ip in self.selectedIndexPaths {
                self.collectionView.deleteItems(at: [ip])
            }
        }, completion: { (success) in
            self.selectedIndexPaths = []
        })
        
    }
    
    func tappedShowGameInfoView() {
        
    }
    
}

//MARK: Animations
extension SetupViewController {
    
    func hideStartGameButton() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.collectionViewContainerBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showStartGameButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
            self.collectionViewContainerBottomConstraint.constant = self.startGameButton.frame.height * -1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}



//MARK: Collection View Setup
extension SetupViewController: UICollectionViewDelegate {
    
    
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
        
        if selectedIndexPaths.count >= 2 && collectionViewContainerBottomConstraint.constant == 0 {
            showStartGameButton()
        } else if selectedIndexPaths.count < 2 {
            hideStartGameButton()
        }
        
        selectedIndexPaths.sort { $0.row > $1.row }

    }
}

//
//
////MARK: Collection view flow Layout
//extension SetupViewController: UICollectionViewDelegateFlowLayout {
//    
//    func configureLayout() {
//        let desiredSpacing: CGFloat = 5
//        let itemWidth = (screenWidth / numberOfCellsPerRow) - (desiredSpacing + 2)
//        let itemHeight = itemWidth * 1.25
//        spacing = desiredSpacing
//        sectionInsets = UIEdgeInsets(top: spacing * 2, left: spacing, bottom: spacing, right: spacing)
//        itemSize = CGSize(width: itemWidth, height: itemHeight)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return itemSize
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return spacing
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return spacing
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//}

