//
//  ZegoUIKitService+Invitation.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/9.
//

import Foundation

extension ZegoUIKit {
    
    public func startInvitation(_ invitees: [String], timeout: UInt32 = 60, type: Int, data: String?) {
        ZegoUIKitCore.shared.sendInvitation(invitees, timeout: timeout, type: type, data: data)
    }
    
    public func cancelInvitation(_ invitees: [String], data: String?) {
        ZegoUIKitCore.shared.cancelInvitation(invitees, data: data)
    }
    
    public func refuseInvitation(_ inviterID: String, data: String?) {
        ZegoUIKitCore.shared.refuseInvitation(inviterID, data: data)
    }
    
    public func acceptInvitation(_ inviterID: String, data: String?) {
        ZegoUIKitCore.shared.acceptInvitation(inviterID, data: data)
    }
    
}
