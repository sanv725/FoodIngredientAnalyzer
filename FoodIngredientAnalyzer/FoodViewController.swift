//
//  ViewController.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/7/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import UIKit


class FoodViewController: UIViewController {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var addFoodSearchBar: UISearchBar!
    @IBOutlet weak var addFoodTextField: UITextField!
    @IBOutlet weak var shadowView: UIView!
    var userImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FoodViewController {
    func applyTheme() {
        centerView.layer.cornerRadius = 5
        centerView.layer.shadowRadius = 5
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOpacity = 0.2
        centerView.layer.shadowOffset = CGSize.zero
        centerView.layer.shadowPath = UIBezierPath(rect: centerView.bounds).cgPath
        
        addFoodTextField.layer.cornerRadius = 22
        
        let cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        cameraButton.addTarget(self, action: #selector(cameraButtonClick), for: .touchUpInside)
        cameraButton.setImage(#imageLiteral(resourceName: "cameraIcon"), for: .normal)
        cameraButton.imageView?.contentMode = .scaleAspectFit
        addFoodTextField.rightView = cameraButton
        addFoodTextField.rightViewMode = .always
        addFoodTextField.delegate = self
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        shadowView.isHidden = true
        addFoodTextField.backgroundColor = UIColorFromRGB("F7F6F7")
        addFoodTextField.textAlignment = .center
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "foodViewToPredictionListSegue" {
            if let destinationViewController = (segue.destination as? UINavigationController)?.topViewController as? PredictionListTableViewController {
                destinationViewController.delegate = self
                destinationViewController.predictionList.append(("beef", false))
                destinationViewController.predictionList.append(("rice", false))
                destinationViewController.predictionList.append(("chicken", false))

            }
        }
    }
}

extension FoodViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        shadowView.isHidden = false
        textField.backgroundColor = .white
        textField.textAlignment = .left
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        var rightViewFrame = textField.rightView?.frame
        rightViewFrame?.size.width = 90
        textField.rightView?.frame = rightViewFrame!
    }
}

extension FoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func cameraButtonClick() {
        self.performSegue(withIdentifier: "foodViewToPredictionListSegue", sender: self)

//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage

        //APIManager.sharedInstance.searchImage(image: image!)
        //APIManager.sharedInstance.imageUpload(image: image!, completion: {
            self.performSegue(withIdentifier: "foodViewToPredictionListSegue", sender: self)
        //})
    }
}

extension FoodViewController: SelectedIngredientsDelegate {
    func selectedIngredients(ingredients: [String]) {
        print(ingredients)
    }
}

protocol SelectedIngredientsDelegate {
    func selectedIngredients(ingredients: [String])
}
