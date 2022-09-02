//
//  ZegoUIKitRoomInfo.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/21.
//

import UIKit
import ZegoExpressEngine

public class ZegoUIKitRoom: NSObject {
    public var roomID: String?
    //public var roomState: ZegoRoomStateChangedReason = .logining
    
    override init() {
        super.init()
    }
    
    init(_ roomID: String) {
        self.roomID = roomID
    }
}
