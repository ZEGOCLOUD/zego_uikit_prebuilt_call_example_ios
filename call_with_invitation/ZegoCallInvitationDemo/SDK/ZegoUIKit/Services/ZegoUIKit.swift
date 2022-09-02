//
//  UIKitService.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import UIKit
import ZegoExpressEngine

public class ZegoUIKit: NSObject {
    
    /// @return UIKitService singleton instance
    public static let shared = ZegoUIKit()
    
    public var localUserInfo: ZegoUIkitUser?
    public var userList: [ZegoUIkitUser] {
        get {
            var users = [ZegoUIkitUser]()
            for participant in ZegoUIKitCore.shared.participantDic.values {
                users.append(participant.toUserInfo())
            }
            return users
        }
    }
    
    public let room: ZegoUIKitRoom? = ZegoUIKitCore.shared.room
    
    private let help: UIKitService_Help = UIKitService_Help()
    
    private override init() {
        super.init()
        ZegoUIKitCore.shared.addEventHandler(self.help)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - appID: <#appID description#>
    ///   - appSign: <#appSign description#>
    public func initWithAppID(appID: UInt32, appSign: String) {
        ZegoUIKitCore.shared.initWithAppID(appID: appID, appSign: appSign)
    }
    
    public func uninit() {
        ZegoUIKitCore.shared.uninit()
    }
    
    public func getVersion() -> String {
        return "1.0"
    }
    
    public func addEventHandler(_ eventHandle: ZegoUIKitEventHandle?) {
        self.help.addEventHandler(eventHandle)
    }

}

fileprivate class UIKitService_Help: NSObject, ZegoUIKitEventHandle {
    
    private let uikitEventDelegates: NSHashTable<ZegoUIKitEventHandle> = NSHashTable(options: .weakMemory)
    
    func addEventHandler(_ eventHandle: ZegoUIKitEventHandle?) {
        self.uikitEventDelegates.add(eventHandle)
    }
    
    func onRemoteUserJoin(_ userList: [ZegoUIkitUser]) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onRemoteUserJoin?(userList)
        }
    }
    
    func onRemoteUserLeave(_ userList: [ZegoUIkitUser]) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onRemoteUserLeave?(userList)
            if ZegoUIKit.shared.userList.count == 1 {
                delegate.onOnlySelfInRoom?()
            }
        }
    }
    
    func onRoomStateChanged(_ reason: ZegoUIKitRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable : Any], roomID: String) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onRoomStateChanged?(reason, errorCode: errorCode, extendedData: extendedData, roomID: roomID)
        }
    }
    
    func onAudioVideoAvailable(_ userList: [ZegoUIkitUser]) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onAudioVideoAvailable?(userList)
        }
    }
    
    func onAudioVideoUnavailable(_ userList: [ZegoUIkitUser]) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onAudioVideoUnavailable?(userList)
        }
    }
    
    func onCameraOn(_ user: ZegoUIkitUser, isOn: Bool) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onCameraOn?(user, isOn: isOn)
        }
    }
    
    func onMicrophoneOn(_ user: ZegoUIkitUser, isOn: Bool) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onMicrophoneOn?(user, isOn: isOn)
        }
    }
    
    func onSoundLevelUpdate(_ userInfo: ZegoUIkitUser, level: Double) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onSoundLevelUpdate?(userInfo, level: level)
        }
    }
    
    func onAudioOutputDeviceChange(_ audioRoute: ZegoUIKitAudioOutputDevice) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onAudioOutputDeviceChange?(audioRoute)
        }
    }
    
    //MARK: - call invitation
    
    func onInvitationReceived(_ inviter: ZegoUIkitUser, type: Int, data: String?) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onInvitationReceived?(inviter, type: type, data: data)
        }
    }
    
    func onInvitationTimeout(_ inviter: ZegoUIkitUser, data: String?) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onInvitationTimeout?(inviter, data: data)
        }
    }
    
    func onInvitationResponseTimeout(_ invitees: [ZegoUIkitUser], data: String?) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onInvitationResponseTimeout?(invitees, data: data)
        }
    }
    
    func onInvitationAccepted(_ invitee: ZegoUIkitUser, data: String?) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onInvitationAccepted?(invitee, data: data)
        }
    }
    
    func onInvitationRefused(_ invitee: ZegoUIkitUser, data: String?) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onInvitationRefused?(invitee, data: data)
        }
    }
    
    func onInvitationCanceled(_ inviter: ZegoUIkitUser, data: String?) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onInvitationCanceled?(inviter, data: data)
        }
    }
}
