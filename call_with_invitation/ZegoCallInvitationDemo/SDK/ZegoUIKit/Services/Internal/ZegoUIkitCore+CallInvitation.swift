//
//  ZegoUIkitCore+CallInvitation.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/9.
//

import Foundation
import ZIM

extension ZegoUIKitCore {
    
    func sendInvitation(_ invitees: [String], timeout: UInt32, type: Int, data: String?) {
        let callInviteConfig: ZIMCallInviteConfig = ZIMCallInviteConfig()
        let dataDict:[String:AnyObject] = [
            "type": type as AnyObject,
            "inviter_name": self.localParticipant?.name as AnyObject,
            "data": data as AnyObject
        ]
        callInviteConfig.timeout = timeout
        callInviteConfig.extendedData = dataDict.jsonString
        self.zim?.callInvite(withInvitees: invitees, config: callInviteConfig, callback: { call_id, info, errorInfo in
            if errorInfo.code == .success {
                self.callObject = ZegoCallObject(call_id, type: ZegoInvitationType.init(rawValue: type) ?? .voiceCall,callStatus: .outgoing, inviterID: self.localParticipant?.userID, invitees: invitees)
            } else {
                
            }
        })
    }
    
    func cancelInvitation(_ invitees: [String], data: String?) {
        guard let callID = self.callObject?.callID else { return }
        let cancelConfig = ZIMCallCancelConfig()
        if let data = data {
            cancelConfig.extendedData = data
        }
        self.zim?.callCancel(withInvitees: invitees, callID: callID, config: cancelConfig, callback: { call_id, errorInvitees, errorInfo in
            if errorInfo.code == .success {
                self.callObject?.resetCall()
            }
        })
    }
    
    func refuseInvitation(_ inviterID: String, data: String?) {
        guard let callID = self.callObject?.callID else { return }
        let rejectConfig = ZIMCallRejectConfig()
        if let data = data {
            rejectConfig.extendedData = data
        }
        self.zim?.callReject(withCallID: callID, config: rejectConfig, callback: { call_id, errorInfo in
            if errorInfo.code == .success {
                self.callObject?.resetCall()
            }
        })
    }
    
    func acceptInvitation(_ inviterID: String, data: String?) {
        guard let callID = self.callObject?.callID else { return }
        let acceptConfig: ZIMCallAcceptConfig = ZIMCallAcceptConfig()
        if let data = data {
            acceptConfig.extendedData = data
        }
        self.zim?.callAccept(withCallID: callID, config: acceptConfig, callback: { call_id, errorInfo in
            if errorInfo.code == .success {
                self.callObject?.callStatus = .calling
            }
        })
    }
    
}

extension ZegoUIKitCore: ZIMEventHandler {
    
    func zim(_ zim: ZIM, callInvitationReceived info: ZIMCallInvitationReceivedInfo, callID: String) {
        if let callObject = self.callObject,
           callObject.callStatus != .free {
            let rejectConfig = ZIMCallRejectConfig()
            self.zim?.callReject(withCallID: callID, config: rejectConfig, callback: { call_id, errorInfo in
                
            })
            return
        }
        let dataDic: Dictionary? = info.extendedData.convertStringToDictionary()
        let type: Int = dataDic?["type"] as! Int
        let data: String? = dataDic?["data"] as? String
        let param: Dictionary = data?.convertStringToDictionary()  ?? [:]
        let user: ZegoUIkitUser = ZegoUIkitUser.init(info.inviter, dataDic?["inviter_name"] as? String ?? "")
        self.callObject = ZegoCallObject(callID, type: ZegoInvitationType.init(rawValue: type) ?? .voiceCall,callStatus: .incoming, inviterID: user.userID, invitees: nil)
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onInvitationReceived?(user, type: type, data: data)
        }
    }
    
    func zim(_ zim: ZIM, callInvitationAccepted info: ZIMCallInvitationAcceptedInfo, callID: String) {
        if self.callObject?.callID == callID {
            self.callObject?.callStatus = .calling
            self.callObject?.acceptInvitees.append(info.invitee)
        }
        for delegate in self.uikitEventDelegates.allObjects {
            let user: ZegoUIkitUser = ZegoUIkitUser.init(info.invitee, "")
            delegate.onInvitationAccepted?(user, data: info.extendedData)
        }
    }
    
    func zim(_ zim: ZIM, callInvitationRejected info: ZIMCallInvitationRejectedInfo, callID: String) {
        if self.callObject?.callID == callID {
            self.callObject?.resetCall()
        }
        for delegate in self.uikitEventDelegates.allObjects {
            let dataDic: Dictionary? = info.extendedData.convertStringToDictionary()
            let data: String? = dataDic?["data"] as? String
            let param: Dictionary = data?.convertStringToDictionary()  ?? [:]
            let user: ZegoUIkitUser = ZegoUIkitUser.init(info.invitee, dataDic?["inviter_name"] as? String ?? "")
            delegate.onInvitationRefused?(user, data: data)
        }
    }
    
    func zim(_ zim: ZIM, callInvitationCancelled info: ZIMCallInvitationCancelledInfo, callID: String) {
        if self.callObject?.callID == callID {
            self.callObject?.resetCall()
        }
        for delegate in self.uikitEventDelegates.allObjects {
            let dataDic: Dictionary? = info.extendedData.convertStringToDictionary()
            let data: String? = dataDic?["data"] as? String
            let param: Dictionary = data?.convertStringToDictionary()  ?? [:]
            let user: ZegoUIkitUser = ZegoUIkitUser.init(info.inviter, dataDic?["inviter_name"] as? String ?? "")
            delegate.onInvitationCanceled?(user, data: data)
        }
    }
    
    func zim(_ zim: ZIM, callInviteesAnsweredTimeout invitees: [String], callID: String) {
        for delegate in self.uikitEventDelegates.allObjects {
            var userList = [ZegoUIkitUser]()
            for userID in invitees {
                let user = ZegoUIkitUser.init(userID, "")
                userList.append(user)
            }
            delegate.onInvitationResponseTimeout?(userList, data: nil)
        }
        if self.callObject?.callID == callID {
            self.callObject?.resetCall()
        }
    }
    
    func zim(_ zim: ZIM, callInvitationTimeout callID: String) {
        for delegate in self.uikitEventDelegates.allObjects {
            guard let userID = self.callObject?.inviterID else { return }
            let user = ZegoUIkitUser.init(userID, "")
            delegate.onInvitationTimeout?(user, data: nil)
        }
        if self.callObject?.callID == callID {
            self.callObject?.resetCall()
        }
    }
    
}
