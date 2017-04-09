//
//  APIManager.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/7/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import Clarifai
import Alamofire

class APIManager {
    
    static let sharedInstance = APIManager()
    
    private let clientId = "zuLrF9UoiqDjuFSbx0vCPhMB4VXcAlhMblAtucOL"
    private let clientSecret = "3gNcrAB6q3ALYMYagsP4IxAZAHszcMgbW3gFZSnZ"
    
    fileprivate let headers: HTTPHeaders = [
        "Authorization": " Client-Id c57a48a251531ae"
    ]
    
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
    
    func imageDelete(deleteHash: String) {
        let url = "https://api.imgur.com/3/image/" + deleteHash
        
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func imageUpload(image: UIImage) {
        let url = "https://api.imgur.com/3/upload.json"
        let imgData: Data = UIImageJPEGRepresentation(image, 1)!
        let encodedData = imgData.base64EncodedString()

        Alamofire.request(url, method: .post, parameters: ["image": encodedData], headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: Any], let data = json["data"] as? [String: Any] {
                    print("JSON: \(json)")
                    let deleteHash = data["deletehash"]
                    print(deleteHash)
                    self.imageDelete(deleteHash: deleteHash as! String)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchImage(image: UIImage) {
        
        let userImage = ClarifaiImage.init(image: image)
        
        //let image = ClarifaiImage.init(url: "https://cdn.pixabay.com/photo/2015/04/08/13/13/food-712665_960_720.jpg")
        
        if let _image = userImage {
            foodModel?.predict(on: [_image], completion: { (response, error) in
                if let concepts = response?.first?.concepts {
                    for concept in concepts {
                        print(concept.conceptName)
                        print(concept.score)
                    }
                }
                print(response)
                print(error)
            })
        }
    }
    
    func setupClarifai() {
        createAccessToken()
        createModel()
    }
}
