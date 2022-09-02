//
//  String+ZGUIkit.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/10.
//

import Foundation

extension String {
    
    func convertStringToDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    static func jsonToArray(jsonString:String)->Array<Dictionary<String, String>>{

        let arr = [Dictionary<String,String>()]
        do{
        
            let data = jsonString.data(using: String.Encoding.utf8)!
            //把NSData对象转换回JSON对象
            let json : Any! = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
        
            return json as! [Dictionary<String, String>]
        }catch{
            return arr
        }
    }
    
}
