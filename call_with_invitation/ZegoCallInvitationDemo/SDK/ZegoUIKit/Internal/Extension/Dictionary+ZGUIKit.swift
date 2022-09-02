//
//  Dictionary+ZGUIKit.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/10.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value:AnyObject {
    
    var jsonString:String {
        do {
            let stringData = try JSONSerialization.data(withJSONObject: self as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let string = String(data: stringData, encoding: String.Encoding.utf8){
                return string
            }
        } catch _ {
            
        }
        return ""
    }
}
