//
//  PredictionListTableViewController.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/10/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import UIKit

class PredictionListTableViewController: UITableViewController {
 
    var predictionList = [(name: String, selected: Bool)]()
    
    var delegate: SelectedIngredientsDelegate?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ingredient List"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonClicked))
    }
    
    func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveButtonClicked() {
        delegate?.selectedIngredients(ingredients: predictionList.filter{ $0.selected }.map{ $0.name } )
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "predictionCell", for: indexPath)
        cell.textLabel?.text = predictionList[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        predictionList[indexPath.row].selected = cell?.accessoryType == .checkmark
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
