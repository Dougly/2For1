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
    let screenHeight = UIScreen.main.bounds.height
    let blurEffectView = UIVisualEffectView()

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
        applyGradients()
        setupMenuView()
        
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        self.blurEffectView.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetViewConroller()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurEffectView.alpha = 0.0
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
            if !menuView.isCollapsed {
                menuView.collapseMenu(withDelay: 0)
            }
        }
        
        if segue.identifier == "addPlayer" {
            let destVC = segue.destination as! CreatePlayerViewController
            destVC.delegate = playerVC
            destVC.blurDelegate = self
        }
    }
    
    func setupMenuView() {
        menuView.setCornerRadius(with: screenHeight * 0.09) // based on constraints in storyboard
        menuView.setShadowColor(with: UIColor.themeMediumGreen)
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
    
    func applyGradients() {
        UIView.applyGradient(to: headerGradientView, topColor: .themeMediumGreen, bottomColor: .themeGreen)
        UIView.applyGradient(to: collectionViewGradientView, topColor: .themeMediumGreen, bottomColor: .themeDarkestGreen)
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

extension SetupViewController: BlurViewDelegate {

    func blurView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.blurEffectView.alpha = 0.75
            self.view.layoutIfNeeded()
        })
    }
    
    func unBlurView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.blurEffectView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
}

