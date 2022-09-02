//
//  UIColor+Hex.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/20.
//

import Foundation
import UIKit

extension UIColor {
    public class func colorWithHexString(_ hexString: String, alpha: CGFloat = 1) -> UIColor {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
     
}

