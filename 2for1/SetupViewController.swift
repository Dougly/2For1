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
    let playerVC = PlayerCollectionView()
    override var prefersStatusBarHidden: Bool { return true }
    
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var menuView: MenuView!
    @IBOutlet weak var playerCollectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerGradientView: UIView!
    @IBOutlet weak var collectionViewGradientView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        applyTapGestures()
        menuView.setShadowColor(with: UIColor.themeMediumGreen)
        UIView.applyGradient(to: headerGradientView, topColor: .themeGreen, bottomColor: .themeMediumGreen)
        UIView.applyGradient(to: collectionViewGradientView, topColor: .themeDarkGreen, bottomColor: .themeMediumGreen)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetViewConroller()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        menuView.setCornerRadius()
        menuView.openCloseMenuDotsView.expandDots()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            let destVC = segue.destination as! GameViewController
            var selectedPlayers: [Player] = []
            for player in store.players {
                if player.isSelected {
                    selectedPlayers.append(player)
                    player.isSelected = false
                }
            }
            destVC.game.players = selectedPlayers
            selectedPlayers = []
            playerCollectionViewBottomConstraint.constant = 0
        }
        
        if segue.identifier == "addPlayer" {
            let destVC = segue.destination as! CreatePlayerViewController
            destVC.delegate = playerVC
        }
    }
}


//MARK: Helper Methods
extension SetupViewController: UpdateCollectionViewProtocol {
    
    func resetViewConroller() {
        store.players.sort { $0.tag! < $1.tag! }
        playerCollectionView.reloadData()
        playerCollectionViewBottomConstraint.constant = 0
        selectedIndexPaths = []
        for player in store.players {
            player.isSelected = false
        }
    }
    
    func reloadCollectionView(withPlayer handle: String) {
        store.players.sort { $0.tag! < $1.tag! }
        for (index, player) in store.players.enumerated() {
            if let tag = player.tag {
                if tag == handle {
                    let indexPath = IndexPath(item: index, section: 0)
                    playerCollectionView.performBatchUpdates({
                        self.playerCollectionView.insertItems(at: [indexPath])
                    }, completion: nil)
                }
            }
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
        playerCollectionView.performBatchUpdates ({
            for ip in self.selectedIndexPaths {
                self.playerCollectionView.deleteItems(at: [ip])
            }
        }, completion: { (success) in
            self.selectedIndexPaths = []
        })
        
    }
    
    func tappedShowGameInfoView() {
        
    }
    
    func setupCollectionView() {
        playerVC.delegate = self
        playerCollectionView.delegate = playerVC
        playerCollectionView.dataSource = playerVC
        playerVC.configureLayout()
    }
    
    func applyTapGestures() {
        for menuItem in menuView.views {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(menuItemTapped))
            menuItem.addGestureRecognizer(tapGR)
        }
    }
}

//MARK: Animations
extension SetupViewController {
    
    func hideStartGameButton() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.playerCollectionViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showStartGameButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
            self.playerCollectionViewBottomConstraint.constant = self.startGameButton.frame.height * -1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

