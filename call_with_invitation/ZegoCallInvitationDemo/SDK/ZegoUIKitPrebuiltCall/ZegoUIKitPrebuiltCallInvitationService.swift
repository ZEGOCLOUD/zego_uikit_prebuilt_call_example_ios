//
//  ZegoUIKitPrebuiltCallInvitationService.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/11.
//

import UIKit
import ZegoUIKitSDK

public protocol ZegoUIKitPrebuiltCallInvitationServiceDelegate: AnyObject {
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIkitPrebuiltCallConfig
}

public class ZegoUIKitPrebuiltCallInvitationService: NSObject {
    
    public static let shared = ZegoUIKitPrebuiltCallInvitationService()
    public weak var delegate: ZegoUIKitPrebuiltCallInvitationServiceDelegate?
    
    let help = ZegoUIKitPrebuiltCallInvitationService_Help()
    
    var isCalling: Bool = false
    
    public override init() {
        ZegoUIKit.shared.addEventHandler(self.help)
        super.init()
    }
    
    public func initWithAppID(_ appID: UInt32, appSign: String, userID: String, userName: String) {
        ZegoUIKit.shared.initWithAppID(appID: appID, appSign: appSign)
        ZegoUIKit.shared.login(userID, userName: userName)
    }
    
}

class ZegoUIKitPrebuiltCallInvitationService_Help: NSObject, ZegoUIKitEventHandle, ZegoUIKitPrebuiltCallVCDelegate {
    
    private let uikitEventDelegates: NSHashTable<ZegoUIKitEventHandle> = NSHashTable(options: .weakMemory)
    
    func addEventHandler(_ eventHandle: ZegoUIKitEventHandle?) {
        self.uikitEventDelegates.add(eventHandle)
    }
    
    func onInvitationReceived(_ inviter: ZegoUIkitUser, type: Int, data: String?) {
        if ZegoUIKitPrebuiltCallInvitationService.shared.isCalling {
            guard let userID = inviter.userID else { return }
            ZegoUIKit.shared.refuseInvitation(userID, data: nil)
        } else {
            let callData = ZegoCallInvitationData()
            let dataDic: Dictionary? = data?.convertStringToDictionary()
            if let dataDic = dataDic {
                callData.callID = dataDic["call_id"] as? String
                let invitees = String.jsonToArray(jsonString: dataDic["invitees"] as! String)
                callData.invitees = self.getInviteeList(invitees)
            }
            callData.inviter = inviter
            callData.type = ZegoInvitationType.init(rawValue: type)
            _ = ZegoCallInvitationDialog.show(callData)
            ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = true
        }
    }
    
    func onInvitationAccepted(_ invitee: ZegoUIkitUser, data: String?) {
        
    }
    
    func onInvitationCanceled(_ inviter: ZegoUIkitUser, data: String?) {
        ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = false
        ZegoCallInvitationDialog.hide()
    }
    
    func onInvitationRefused(_ invitee: ZegoUIkitUser, data: String?) {
        ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = false
    }
    
    func onInvitationTimeout(_ inviter: ZegoUIkitUser, data: String?) {
        ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = false
        ZegoCallInvitationDialog.hide()
    }
    
    func onInvitationResponseTimeout(_ invitees: [ZegoUIkitUser], data: String?) {
        ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = false
        ZegoCallInvitationDialog.hide()
    }
    
    func onHangUp(_ isHandup: Bool) {
        if isHandup {
            ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = false
        }
    }
    
    func onOnlySelfInRoom() {
        ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = false
    }
    
    func getInviteeList(_ invitees: [Dictionary<String,String>]) -> [ZegoUIkitUser] {
        var inviteeList = [ZegoUIkitUser]()
        for dict in invitees {
            if let userID = dict["user_id"],
               let userName = dict["user_name"]
            {
                let user = ZegoUIkitUser.init(userID, userName)
                inviteeList.append(user)
            }
        }
        return inviteeList
    }
}

