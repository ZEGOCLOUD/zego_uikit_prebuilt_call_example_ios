//
//  Array+ZGUIKit.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/10.
//

import Foundation

extension Array {
    
    func convertArrayToString() -> String {
        var result:String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
}
