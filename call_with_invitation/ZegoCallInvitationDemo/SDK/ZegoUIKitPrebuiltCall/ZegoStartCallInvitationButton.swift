//
//  ZegoStartCallInvitationButton.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/12.
//

import UIKit
import ZegoUIKitSDK

public class ZegoStartCallInvitationButton: ZegoStartInvitationButton {

    public var isVideoCall: Bool = false {
        didSet {
            self.type = isVideoCall ? 1 : 0
        }
    }
    public var inviteeList: [ZegoUIkitUser] = [] {
        didSet {
            self.invitees.removeAll()
            for user in inviteeList {
                if let userID = user.userID {
                    self.invitees.append(userID)
                }
            }
        }
    }
    
    public override init(_ type: ZegoInvitationType) {
        super.init(type)
        self.isVideoCall = type == .videoCall ? true : false
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func buttonClick() {
        guard let userID = ZegoUIKit.shared.localUserInfo?.userID else { return }
        let callData = ZegoCallInvitationData()
        callData.callID = String(format: "call_%@", userID)
        callData.invitees = self.inviteeList
        callData.inviter = ZegoUIKit.shared.localUserInfo
        callData.type = isVideoCall ? .videoCall : .voiceCall
        if isVideoCall {
            ZegoUIKit.shared.turnCameraOn(userID, isOn: true)
        }
        let vc = UINib.init(nibName: "ZegoUIKitPrebuiltCallWaitingVC", bundle: Bundle(for: ZegoUIKitPrebuiltCallWaitingVC.self)).instantiate(withOwner: nil, options: nil).first as! ZegoUIKitPrebuiltCallWaitingVC
        vc.isInviter = true
        vc.callInvitationData = callData
        vc.modalPresentationStyle = .fullScreen
        currentViewController()?.present(vc, animated: true, completion: nil)
        self.data = ["call_id": callData.callID as AnyObject, "invitees": self.conversionInvitees() as AnyObject].jsonString
        ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = true
        super.buttonClick()
    }
    
    func conversionInvitees() -> String {
        var newInvitees: [Dictionary<String,String>] = []
        for user in self.inviteeList {
            let userDict: Dictionary<String, String> = ["user_id": user.userID ?? "", "user_name": user.userName ?? ""]
            newInvitees.append(userDict)
        }
        return newInvitees.convertArrayToString()
    }
    
}
