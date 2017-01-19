//
//  CreatePlayerViewController.swift
//  2for1
//
//  Created by Douglas Galante on 1/5/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit

class CreatePlayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let store = DataStore.sharedInstance
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var handleTextField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var createPlayerView: CreatePlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func addPictureTapped(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let tag = handleTextField.text!
        store.savePlayer(firstName, lastName: lastName, tag: tag)
        self.dismiss(animated: true, completion: nil)
    }
}
