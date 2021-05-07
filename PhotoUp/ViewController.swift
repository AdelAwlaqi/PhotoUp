//
//  ViewController.swift
//  PhotoUp
//
//  Created by fatma on 25/09/1442 AH.
//

import UIKit
import Firebase

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var img: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(tap)
    }

    @objc func imgTapped() {
        launchImgPicker()
    }
    @IBAction func OpenPressed(_ sender: Any) {
        uploadImage()
    }
    
    
    
    
    
    func uploadImage() {
        guard let image = img.image else {
              print("no photos selected!")
                return
        }
        print("photo is uploading")
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("/images/\(UUID().uuidString).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
               
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    
                    return
                }
                
                guard let url = url else { return }
                //self.uploadDocument(url: url.absoluteString)
            })
        }
    
}

}

extension ViewController : UIImagePickerControllerDelegate {
    
    func launchImgPicker() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let img = info[.originalImage] as? UIImage else { return }
        
        self.img.contentMode = .scaleAspectFill
        self.img.image = img
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
