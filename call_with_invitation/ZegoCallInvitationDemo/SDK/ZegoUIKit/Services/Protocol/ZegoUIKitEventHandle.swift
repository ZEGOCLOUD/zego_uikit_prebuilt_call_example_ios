//
//  ZegoUIKitEvent.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import UIKit
import ZegoExpressEngine

@objc public protocol ZegoUIKitEventHandle: AnyObject {
    
    //MARK: - user
    @objc optional func onRemoteUserJoin(_ userList:[ZegoUIkitUser])
    @objc optional func onRemoteUserLeave(_ userList:[ZegoUIkitUser])
    @objc optional func onOnlySelfInRoom()
    
    //MARK: - room
    @objc optional func onRoomStateChanged(_ reason: ZegoUIKitRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable : Any], roomID: String)
    
    //MARK: -audio video
    @objc optional func onCameraOn(_ user: ZegoUIkitUser, isOn: Bool)
    @objc optional func onMicrophoneOn(_ user: ZegoUIkitUser, isOn: Bool)
    @objc optional func onSoundLevelUpdate(_ userInfo: ZegoUIkitUser, level: Double)
    @objc optional func onAudioVideoAvailable(_ userList: [ZegoUIkitUser])
    @objc optional func onAudioVideoUnavailable(_ userList: [ZegoUIkitUser])
    @objc optional func onAudioOutputDeviceChange(_ audioRoute: ZegoUIKitAudioOutputDevice)
    
    //MARK: - call invitation
    @objc optional func onInvitationReceived(_ inviter: ZegoUIkitUser, type: Int, data: String?)
    @objc optional func onInvitationTimeout(_ inviter: ZegoUIkitUser, data: String?)
    @objc optional func onInvitationResponseTimeout(_ invitees: [ZegoUIkitUser], data: String?)
    @objc optional func onInvitationAccepted(_ invitee: ZegoUIkitUser, data: String?)
    @objc optional func onInvitationRefused(_ invitee: ZegoUIkitUser, data: String?)
    @objc optional func onInvitationCanceled(_ inviter: ZegoUIkitUser, data: String?)
}

