//
//  SetupViewController.swift
//  2for1
//
//  Created by Douglas Galante on 1/5/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    var players: [Player] = []
    
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var startGameButton: UIButton!
    
    //Collection View Variables
    let screenWidth = UIScreen.main.bounds.width
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var numberOfCellsPerRow: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createPlayer" {
            let destVC = segue.destination as! CreatePlayerViewController
            destVC.delegate = self
        }
    }
}

extension SetupViewController: CreatePlayerDelegate {
    
    func createPlayer(tag: String, firstName: String, lastName: String) {
        let newPlayer = Player(tag: tag, firstName: firstName, lastName: lastName)
        players.append(newPlayer)
    }
}


//MARK: Collection View Setup
extension SetupViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath)
        
        return cell
    }
    
}

//MARK: Collection view flow Layout
extension SetupViewController: UICollectionViewDelegateFlowLayout {
    
    func configureLayout () {
        let desiredSpacing: CGFloat = 2
        let itemWidth = (playerCollectionView.frame.width / numberOfCellsPerRow) - (desiredSpacing * numberOfCellsPerRow + 1)
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
