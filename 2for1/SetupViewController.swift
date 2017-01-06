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
    var selectedPlayers: [Player] = []
    
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var startGameButton: UIButton!
    
    //Collection View Variables
    let screenWidth = UIScreen.main.bounds.width
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var numberOfCellsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //sort players array
        store.players.sort { (p1, p2) -> Bool in
            return p1.firstName < p2.firstName
        }
        
        configureLayout()
        playerCollectionView.reloadData()
    }
    
    func deletePlayer() {
        //store.persistentContainer.viewContext.delete(player)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            let destVC = segue.destination as! GameViewController
            destVC.game.players = selectedPlayers
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
        cell.nameLabel.text = "\(player.firstName) \(player.lastName)"
        cell.pictureImageView.image = player.pic
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomPlayerCell
        
        if cell.pictureImageView.image == #imageLiteral(resourceName: "slime") {
            cell.pictureImageView.image = #imageLiteral(resourceName: "childCare")
            selectedPlayers.append(store.players[indexPath.item])
        } else {
            cell.pictureImageView.image = #imageLiteral(resourceName: "slime")
        }
        
    
    }
    
}

//MARK: Collection view flow Layout
extension SetupViewController: UICollectionViewDelegateFlowLayout {
    
    func configureLayout () {
        let desiredSpacing: CGFloat = 2
        let itemWidth = (screenWidth / numberOfCellsPerRow) - (desiredSpacing + 1)
        let itemHeight = itemWidth
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
