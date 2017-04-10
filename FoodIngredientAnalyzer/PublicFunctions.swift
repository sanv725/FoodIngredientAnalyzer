//
//  PublicFunctions.swift
//  FoodIngredientAnalyzer
//
//  Created by Sanju Varghese on 4/9/17.
//  Copyright © 2017 SanjuV. All rights reserved.
//

import UIKit

public func UIColorFromRGB(_ colorCode: String, alpha: Float = 1.0) -> UIColor {
    let scanner = Scanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt32(&color)
    
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
    let b = CGFloat(Float(Int(color) & mask)/255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
}

