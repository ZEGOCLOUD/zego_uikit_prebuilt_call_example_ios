//
//  UIKitService+User.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import Foundation
import ZegoExpressEngine

extension ZegoUIKit {
    
    public func login(_ userID: String, userName: String) {
        self.localUserInfo = ZegoUIkitUser.init(userID, userName)
        ZegoUIKitCore.shared.login(userID, userName: userName)
    }
    
    public func getUser(_ userID: String) -> ZegoUIkitUser? {
        return ZegoUIKitCore.shared.participantDic[userID]?.toUserInfo()
    }
    
}
