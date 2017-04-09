//
//  ViewController.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/7/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        APIManager.sharedInstance.setupClarifai()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func buttonClicked(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage

        //APIManager.sharedInstance.searchImage(image: image!)
        APIManager.sharedInstance.imageUpload(image: image!)
        APIManager.sharedInstance.imageDelete(deleteHash: "tULLA1xzTyxEMdF")
        
        //        let imgData: NSData = NSData(data: UIImageJPEGRepresentation(image!, 1)!)
        
        //userImage = UIImage(data: UIImageJPEGRepresentation(image!, 1)!)!
        
//        APIManager.sharedInstance.searchImage(image: image!)
        
        //var imgData: NSData = NSData(data: UIImageJPEGRepresentation((image)!, 1)!)
//         let imgData: Data = UIImagePNGRepresentation(image!)!
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        //var imageSize: Int = imgData.length
        //print("size of image in KB: %f ", Double(imageSize) / 1024.0)
    }
}
