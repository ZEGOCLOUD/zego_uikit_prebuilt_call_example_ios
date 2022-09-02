//
//  UserInfo.swift
//  ZegoUIKitExample
//
//  Created by zego on 2022/7/14.
//

import UIKit

public class ZegoUIkitUser: NSObject, Codable {
    
    public var userID: String?
    public var userName: String?
    
    override init() {
        
    }
    
    public init(_ userID: String, _ userName: String) {
        self.userID = userID
        self.userName = userName
    }
}
