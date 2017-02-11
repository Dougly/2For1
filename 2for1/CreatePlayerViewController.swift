//
//  CreatePlayerViewController.swift
//  2for1
//
//  Created by Douglas Galante on 1/5/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit
import AVFoundation

class CreatePlayerViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    var delegate: UpdateCollectionViewDelegate?
    var blurDelegate: BlurViewDelegate?
    override var prefersStatusBarHidden: Bool { return true }
    
    @IBOutlet weak var createPlayerView: CreatePlayerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurDelegate?.blurView()
    }
    
}



//MARK: Taking and Saving Picture and Player Info
extension CreatePlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func addPictureTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        createPlayerView.playerPictureImageView.image = image
        createPlayerView.placeholderView.isHidden = true
    }

    
    func plusViewTapped() {
        let firstName = createPlayerView.firstNameTextField.text!
        let lastName = createPlayerView.lastNameTextField.text!
        let tag = createPlayerView.handleTextField.text!
        if !createPlayerValidation(firstName: firstName, lastName: lastName, tag: tag) { return }
        
        if let image = createPlayerView.playerPictureImageView.image {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(firstName + lastName + tag).png")
            
            do {
                if let pngImageData = UIImagePNGRepresentation(image) {
                    print("try write image data")
                    try pngImageData.write(to: fileURL, options: .atomic)
                }
            } catch {
                print("couldnt write to file")
            }
            store.savePlayer(firstName, lastName: lastName, tag: tag, file: "\(firstName + lastName + tag).png")
        } else {
            store.savePlayer(firstName, lastName: lastName, tag: tag, file: "\(firstName + lastName + tag).png")
        }
        
        
        self.blurDelegate?.unBlurView()
        self.dismiss(animated: true, completion: {
            if let delegate = self.delegate {
                delegate.reloadCollectionView(withPlayer: tag)
            }
        })
    }
    
    
    func createPlayerValidation(firstName: String, lastName: String, tag: String) -> Bool {
        
        //makes sure all fields are filled
        if firstName == "" {
            animateInvalidTextIn(textField: createPlayerView.firstNameTextField)
            return false
        } else if lastName == "" {
            animateInvalidTextIn(textField: createPlayerView.lastNameTextField)
            return false
        } else if tag == "" {
            animateInvalidTextIn(textField: createPlayerView.handleTextField)
            return false
        }
        
        //prevents crash if a png already exists
        let fileManager = FileManager.default
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.path
        let filePath = documentsURL.appendingPathComponent("\(firstName + lastName + tag).png").path
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            for file in files {
                if "\(documentPath)/\(file)" == filePath {
                    print("did not save - found pre-existing png file")
                    return false
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        return true
    }
    
    
    func animateInvalidTextIn(textField: UITextField) {
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [], animations: {
            
            if textField.backgroundColor == .white {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    textField.backgroundColor = .themeOrange
                    self.view.layoutIfNeeded()
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                    textField.backgroundColor = .white
                    self.view.layoutIfNeeded()
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                    textField.backgroundColor = .themeOrange
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    textField.backgroundColor = .white
                    self.view.layoutIfNeeded()
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                    textField.backgroundColor = .themeOrange
                    self.view.layoutIfNeeded()
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                    textField.backgroundColor = .white
                    self.view.layoutIfNeeded()
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                    textField.backgroundColor = .themeOrange
                    self.view.layoutIfNeeded()
                })
            }
        }, completion: nil)
    }

    
}


//MARK: Gestures
extension CreatePlayerViewController {
 
    @IBAction func swipeDismiss() {
        self.blurDelegate?.unBlurView()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func addGestures() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(plusViewTapped))
        createPlayerView.addPlayerView.addGestureRecognizer(tapGR)
        createPlayerView.firstNameTextField.becomeFirstResponder()
        createPlayerView.setCornerRadius(with: UIScreen.main.bounds.height * 0.5)
        
        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(addPictureTapped))
        createPlayerView.playerPictureImageView.addGestureRecognizer(tapGR3)
        
        let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeDismiss))
        swipeGR.direction = .down
        createPlayerView.addGestureRecognizer(swipeGR)
    }
    
}




