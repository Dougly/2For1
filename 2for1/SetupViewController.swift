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
        setBlur()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetViewConroller()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "startGame":
                let destVC = segue.destination as! GameViewController
                segueToGame(gameViewController: destVC)
            case "addPlayer":
                let destVC = segue.destination as! CreatePlayerViewController
                destVC.delegate = playerVC
                destVC.blurDelegate = self
            case "showInstructions":
                let destVC = segue.destination as! GameInstructionsViewController
                destVC.delegate = self
            default:
                break
            }
        }
    }
    
    
}


//MARK: Helper Methods
extension SetupViewController: UpdateCollectionViewDelegate {
    
    func segueToGame(gameViewController: GameViewController) {
        var selectedPlayers: [Player] = []
        for player in store.players {
            if player.isSelected {
                selectedPlayers.append(player)
                player.isSelected = false
            }
        }
        gameViewController.game.players = selectedPlayers
        playerCollectionViewBottomConstraint.constant = 0
        if !menuView.isCollapsed {
            menuView.collapseMenu(withDelay: 0)
        }
    }
    
    
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
        selectedIndexPaths = []
        for (index, player) in store.players.enumerated() {
            if player.isSelected {
                let indexPath = IndexPath(item: index, section: 0)
                selectedIndexPaths.append(indexPath)
            }
        }
    }

    
    func setupCollectionView() {
        playerVC.delegate = self
        playerCollectionView.delegate = playerVC
        playerCollectionView.dataSource = playerVC
        playerVC.configureLayout()
    }

    
    func applyGradients() {
        UIView.applyGradient(to: headerGradientView, topColor: .themeMediumGreen, bottomColor: .themeGreen)
        UIView.applyGradient(to: collectionViewGradientView, topColor: .themeMediumGreen, bottomColor: .themeDarkestGreen)
    }
    
    
    func setupMenuView() {
        menuView.setCornerRadius(with: screenHeight * 0.09) // based on constraints in storyboard
        menuView.setShadowColor(with: UIColor.themeMediumGreen)
    }
    
    
}



//MARK: Menu Options
extension SetupViewController {
    
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
            let player = self.store.players[ip.row]
            store.players.remove(at: ip.row)
            store.persistentContainer.viewContext.delete(player)
            clearImageData(for: player)
        }
        store.saveContext()
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
        performSegue(withIdentifier: "showInstructions", sender: self)
        blurView()
    }
    
    
    func clearImageData(for player: Player) {
        let fileManager = FileManager.default
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let file = player.file
        
        let documentPath = documentsURL.path
        
        do {
            if let file = file {
                let filePath = documentsURL.appendingPathComponent(file).path
                try fileManager.removeItem(atPath: filePath)
                
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
            }
        } catch {
            print("Could not clear image from document directory: \(error)")
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



//MARK: Blur View Delegate
extension SetupViewController: BlurViewDelegate {

    func blurView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    
    func unBlurView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blurEffectView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    
    func setBlur() {
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.blurEffectView.alpha = 0.0
    }
    
    
}

