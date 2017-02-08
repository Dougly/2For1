//
//  CreatePlayerViewController.swift
//  2for1
//
//  Created by Douglas Galante on 1/5/17.
//  Copyright © 2017 Flatiron. All rights reserved.
//

import UIKit
import AVFoundation

class CreatePlayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let store = DataStore.sharedInstance
    var delegate: UpdateCollectionViewProtocol?
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
    
    @IBAction func xViewTapped() {
        self.blurDelegate?.unBlurView()
        self.dismiss(animated: true, completion: nil)
    }
    
    func addPictureTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
//        createPlayerView.playerPictureImageView.image = image
//        createPlayerView.placeholderView.isHidden = true
//    }
//
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        createPlayerView.playerPictureImageView.image = image
        createPlayerView.placeholderView.isHidden = true
    
    }
//        let imageKey = UIImagePickerControllerOriginalImage
//        var image = UIImage()
//        if let value = info[imageKey] {
//            print("got original Image")
//            image = value as! UIImage
//        }
//        
//        createPlayerView.playerPictureImageView.image = image
////        let imageData = UIImagePNGRepresentation(image)
////        if let imageData = imageData {
////            let pngImage = UIImage(data: imageData)
////            if let pngImage = pngImage {
////                UIImageWriteToSavedPhotosAlbum(pngImage, nil, nil, nil)
////            }
////        }
//    }
    
    func plusViewTapped() {
        let firstName = createPlayerView.firstNameTextField.text!
        let lastName = createPlayerView.lastNameTextField.text!
        let tag = createPlayerView.handleTextField.text!
        
        let image = createPlayerView.playerPictureImageView.image!
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

        
        
        store.savePlayer(firstName, lastName: lastName, tag: tag, file: "\(firstName + lastName + tag).png", image: image)
        self.blurDelegate?.unBlurView()
        self.dismiss(animated: true, completion: {
            if let delegate = self.delegate {
                delegate.reloadCollectionView(withPlayer: tag)
            }
        })
        
    }
    
    func addGestures() {
    
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(plusViewTapped))
        createPlayerView.addPlayerView.addGestureRecognizer(tapGR)
        createPlayerView.firstNameTextField.becomeFirstResponder()
        createPlayerView.setCornerRadius(with: UIScreen.main.bounds.height * 0.5)
        
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(xViewTapped))
        createPlayerView.xImageView.addGestureRecognizer(tapGR2)
        
        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(addPictureTapped))
        createPlayerView.playerPictureImageView.addGestureRecognizer(tapGR3)
        
        let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(xViewTapped))
        swipeGR.direction = .down
        createPlayerView.addGestureRecognizer(swipeGR)
    
    }
}
