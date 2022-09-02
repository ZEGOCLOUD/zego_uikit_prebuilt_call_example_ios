//
//  UIKitService+Room.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import Foundation
import ZegoExpressEngine

extension ZegoUIKit {
    
    public func joinRoom(_ userID: String, userName: String, roomID: String) {
        ZegoUIKitCore.shared.joinRoom(userID, userName: userName, roomID: roomID)
    }
    
    public func leaveRoom() {
        ZegoUIKitCore.shared.leaveRoom()
    }
}
