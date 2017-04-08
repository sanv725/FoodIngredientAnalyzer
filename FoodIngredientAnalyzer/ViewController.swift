//
//  ViewController.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/7/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        APIManager.sharedInstance.setupClarifai()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(_ sender: Any) {
        
        APIManager.sharedInstance.searchImage()
    }

}

