//
//  ViewController.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/7/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import UIKit
import HTagView
import SVProgressHUD

class FoodViewController: UIViewController {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var addFoodTextField: UITextField!
    @IBOutlet weak var tagView: HTagView!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var userImage = UIImage()
    var ingredientList = [String]()
    var selectedIngredients = [String]() {
        didSet {
            tagView.reloadData()
        }
    }
    
    let searchResults: [String] = ["Ham", "Eggplant", "Lettuce", "Lime", "Olive"]

    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme()

        tagView.delegate = self
        tagView.dataSource = self
        tagView.multiselect = false
        tagView.marg = 20
        tagView.btwTags = 20
        tagView.btwLines = 20
        tagView.fontSize = 12
        tagView.tagMainBackColor = UIColorFromRGB("F7F6F7")
        tagView.tagMainTextColor = UIColor.darkGray
        tagView.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        tagView.reloadData()
        
        searchResultTableView.isHidden = true
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
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

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !selectedIngredients.contains(searchResults[indexPath.row]) {
            selectedIngredients.append(searchResults[indexPath.row])
            tagView.reloadData()
        }
        searchResultTableView.isHidden = true
        addFoodTextField.endEditing(true)
    }
}

extension FoodViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textAlignment = .left
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        var rightViewFrame = textField.rightView?.frame
        rightViewFrame?.size.width = 90
        textField.rightView?.frame = rightViewFrame!
        searchResultTableView.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchResultTableView.isHidden = true
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

        SVProgressHUD.show(withStatus: "Uploading image...")
        APIManager.sharedInstance.imageUpload(image: image!, completion: { urlString, deleteHash in
            SVProgressHUD.show(withStatus: "Predicting ingredients...")
            APIManager.sharedInstance.searchByImageUrl(urlString: urlString, deleteHash: deleteHash, completion: { ingredientList in
                SVProgressHUD.dismiss()
                self.ingredientList = ingredientList
                self.performSegue(withIdentifier: "foodViewToPredictionListSegue", sender: self)
            })
        })
    }
}

extension FoodViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let isDescendant = (touch.view?.isDescendant(of: searchResultTableView)), isDescendant {
            return false
        }
        return true
    }
}

extension FoodViewController: SelectedIngredientsDelegate {
    func selectedIngredients(ingredients: [String]) {
        selectedIngredients.append(contentsOf: ingredients)
    }
}

protocol SelectedIngredientsDelegate {
    func selectedIngredients(ingredients: [String])
}
