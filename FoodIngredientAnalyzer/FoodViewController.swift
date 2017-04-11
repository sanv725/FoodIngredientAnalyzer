//
//  ViewController.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/7/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import UIKit
import HTagView

class FoodViewController: UIViewController {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var addFoodTextField: UITextField!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var tagView: HTagView!
    
    var userImage = UIImage()
    var ingredientList = [String]()
    var selectedIngredients = [String]() {
        didSet {
            tagView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme()
        
        tagView.delegate = self
        tagView.dataSource = self
        tagView.multiselect = false
        tagView.marg = 20
        tagView.btwTags = 20
        tagView.btwLines = 20
        tagView.fontSize = 15
        tagView.tagMainBackColor = UIColor(red: 121/255, green: 196/255, blue: 1, alpha: 1)
        tagView.tagMainTextColor = UIColor.white
        tagView.tagSecondBackColor = UIColor.lightGray
        tagView.tagSecondTextColor = UIColor.darkText
        tagView.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        tagView.reloadData()
        
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
                for ingredient in ingredientList {
                    destinationViewController.predictionList.append((ingredient, false))
                }
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

extension FoodViewController: HTagViewDelegate, HTagViewDataSource {
    // MARK: - HTagViewDataSource
    func numberOfTags(_ tagView: HTagView) -> Int {
        return selectedIngredients.count
    }
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        return selectedIngredients[index]
    }
    
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        return .cancel
    }
    
    // MARK: - HTagViewDelegate
    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int) {
        selectedIngredients.remove(at: index)
        tagView.reloadData()
    }
}

extension FoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func cameraButtonClick() {
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

        APIManager.sharedInstance.imageUpload(image: image!, completion: { urlString, deleteHash in
            APIManager.sharedInstance.searchByImageUrl(urlString: urlString, deleteHash: deleteHash, completion: { ingredientList in
                self.ingredientList = ingredientList
                self.performSegue(withIdentifier: "foodViewToPredictionListSegue", sender: self)
            })
        })
    }
}

extension FoodViewController: SelectedIngredientsDelegate {
    func selectedIngredients(ingredients: [String]) {
        selectedIngredients = ingredients
    }
}

protocol SelectedIngredientsDelegate {
    func selectedIngredients(ingredients: [String])
}
