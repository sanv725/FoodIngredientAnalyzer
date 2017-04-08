//
//  APIManager.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/7/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import Clarifai

class APIManager {
    
    static let sharedInstance = APIManager()
    
    private let clientId = "zuLrF9UoiqDjuFSbx0vCPhMB4VXcAlhMblAtucOL"
    private let clientSecret = "3gNcrAB6q3ALYMYagsP4IxAZAHszcMgbW3gFZSnZ"
    
    private var accessToken = ""
    
    private var clarifaiApp: ClarifaiApp?
    private var foodModel: ClarifaiModel?
    
    private func createAccessToken() {
        clarifaiApp = ClarifaiApp.init(appID: clientId, appSecret: clientSecret)
        
        accessToken = clarifaiApp?.accessToken ?? ""
    }
    
    private func createModel() {
        clarifaiApp?.getModelByName("food-items-v1.0", completion: { clarifaiModel, error in
            self.foodModel = clarifaiModel
        })
    }
    
    func searchImage() {
        let image = ClarifaiImage.init(url: "https://cdn.pixabay.com/photo/2015/04/08/13/13/food-712665_960_720.jpg")
        
        if let _image = image {
            foodModel?.predict(on: [_image], completion: { (response, error) in
                if let concepts = response?.first?.concepts {
                    for concept in concepts {
                        print(concept.conceptName)
                        print(concept.score)
                    }
                }
            })
        }
    }
    
    func setupClarifai() {
        createAccessToken()
        createModel()
    }
}
