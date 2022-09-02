//
//  ZegoUIKitCore.swift
//  ZegoUIKitExample
//
//  Created by zego on 2022/7/15.
//

import UIKit
import ZegoExpressEngine
import ZIM

internal class ZegoParticipant: NSObject {
    let userID: String
    var name: String = ""
    var streamID: String = ""
    var renderView: UIView = UIView()
    var camera: Bool = false
    var mic: Bool = false
    var network: ZegoStreamQualityLevel = .excellent
    var videoDisPlayMode: ZegoUIKitVideoFillMode = .aspectFill
    
    init(userID: String, name: String = "") {
        self.userID = userID
        self.name = name
        super.init()
    }
    
    func toUserInfo() -> ZegoUIkitUser {
        return ZegoUIkitUser.init(userID, name)
    }
    
}

enum ZegoCallStatus: Int {
    case free = 0
    case outgoing = 1
    case incoming = 2
    case calling = 3
}

internal class ZegoCallObject: NSObject {
    var inviterID: String?
    var invitees: [String]?
    var acceptInvitees = [String]()
    var callID: String?
    var callStatus: ZegoCallStatus = .free
    var type: Int = 0
    
    init(_ callID: String, type: ZegoInvitationType, callStatus: ZegoCallStatus, inviterID: String?, invitees: [String]?) {
        self.callID = callID
        self.callStatus = callStatus
        self.inviterID = inviterID
        self.invitees = invitees
    }
    
    func resetCall() {
        self.callID = nil
        self.callStatus = .free
        self.inviterID = nil
        self.invitees = nil
        ZegoExpressEngine.shared().stopPreview()
    }
}

internal class ZegoUIKitCore: NSObject {
    
    static let shared = ZegoUIKitCore()
    
    // key is UserID, value is participant model
    var participantDic: Dictionary<String, ZegoParticipant> = Dictionary()
    var streamDic: Dictionary<String, String> = Dictionary()
    var localParticipant: ZegoParticipant?
    var room: ZegoUIKitRoom?
    var zim: ZIM?
    var callObject: ZegoCallObject?
    
    internal let uikitEventDelegates: NSHashTable<ZegoUIKitEventHandle> = NSHashTable(options: .weakMemory)
    
    override init() {
        super.init()
    }
}

extension ZegoUIKitCore {
    func addEventHandler(_ eventHandle: ZegoUIKitEventHandle?) {
        self.uikitEventDelegates.add(eventHandle)
    }
    
    func initWithAppID(appID: UInt32, appSign: String) {
        let profile = ZegoEngineProfile()
        profile.appID = appID
        profile.appSign = appSign
        profile.scenario = .general
        let config: ZegoEngineConfig = ZegoEngineConfig()
        config.advancedConfig = ["notify_remote_device_unknown_status": "true", "notify_remote_device_init_status":"true"]
        ZegoExpressEngine.setEngineConfig(config)
        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
        
        let zimConfig: ZIMAppConfig = ZIMAppConfig()
        zimConfig.appID = appID
        zimConfig.appSign = appSign
        self.zim = ZIM.create(with: zimConfig)
        self.zim?.setEventHandler(self)
    }
    
    func uninit() {
        ZegoExpressEngine.destroy(nil)
        self.zim?.destroy()
        self.zim = nil
    }
    
    func login(_ userID: String, userName: String) {
        let userInfo: ZIMUserInfo = ZIMUserInfo()
        userInfo.userID = userID
        userInfo.userName = userName
        
        if self.localParticipant == nil {
            self.localParticipant = ZegoParticipant(userID: userID, name: userName)
        }
        self.zim?.login(with: userInfo, token: "", callback: { error in
            
        })
    }
    
    //MARK -- room 相关
    func joinRoom(_ userID: String, userName: String, roomID: String) {
        self.localParticipant = nil
        self.participantDic.removeAll()
        self.streamDic.removeAll()
        self.room = ZegoUIKitRoom.init(roomID)
        let user: ZegoUser = ZegoUser()
        user.userID = userID
        user.userName = userName
        
        let participant: ZegoParticipant = self.localParticipant ?? ZegoParticipant(userID: user.userID, name: user.userName)
        participant.streamID = generateStreamID(userID: participant.userID, roomID: roomID)
        self.participantDic[participant.userID] = participant
        self.streamDic[participant.streamID] = participant.userID
        self.localParticipant = participant
        
        let config: ZegoRoomConfig = ZegoRoomConfig()
        config.isUserStatusNotify = true
        ZegoExpressEngine.shared().loginRoom(roomID, user: user, config: config)
        
        // monitor sound level
        ZegoExpressEngine.shared().startSoundLevelMonitor(1000)
    }
    
    func leaveRoom() {
        self.participantDic.removeAll()
        self.streamDic.removeAll()
        self.callObject?.resetCall()
        ZegoExpressEngine.shared().stopSoundLevelMonitor()
        ZegoExpressEngine.shared().stopPreview()
        ZegoExpressEngine.shared().stopPublishingStream()
        ZegoExpressEngine.shared().logoutRoom { errorCode, dict in
            self.room = nil
        }
    }
    
    //MARK: --
    func useFrontFacingCamera(isFrontFacing: Bool) {
        ZegoExpressEngine.shared().useFrontCamera(isFrontFacing)
    }
    
    func enableSpeaker(enable: Bool) {
        ZegoExpressEngine.shared().setAudioRouteToSpeaker(enable)
    }
    
    func audioOutputDeviceType() -> ZegoAudioRoute? {
        return ZegoExpressEngine.shared().getAudioRouteType()
    }
    
    func isMicDeviceOn(_ userID: String) -> Bool {
        if self.isMySelf(userID) {
            return self.localParticipant?.mic ?? false
        } else {
            //TODO:逻辑待完善
            return false
        }
    }
    
    func isCameraDeviceOn(_ userID: String) -> Bool {
        if self.isMySelf(userID) {
            return self.localParticipant?.camera ?? false
        } else {
            //TODO:逻辑待完善
            return false
        }
    }
    
    func turnMicDeviceOn(_ userID: String, isOn: Bool) {
        if self.isMySelf(userID) {
            self.localParticipant?.mic = isOn
            ZegoExpressEngine.shared().muteMicrophone(!isOn)
            if isOn {
                self.startPublishStream()
            } else {
                if !(self.localParticipant?.camera ?? false) {
                    self.stopPublishStream()
                }
            }
            for delegate in self.uikitEventDelegates.allObjects {
                guard let localParticipant = self.localParticipant else { return }
                delegate.onMicrophoneOn?(localParticipant.toUserInfo(), isOn: isOn)
            }
        } else {
            // TODO: 第一期暂时不支持开关其他用户麦克风
        }
    }
    
    func turnCameraDeviceOn(_ userID: String, isOn: Bool) {
        if self.isMySelf(userID) {
            self.localParticipant?.camera = isOn
            ZegoExpressEngine.shared().enableCamera(isOn)
            if isOn {
                self.startPublishStream()
                if let rendView = self.localParticipant?.renderView {
                    ZegoExpressEngine.shared().startPreview(generateCanvas(rendView: rendView, videoMode: self.localParticipant?.videoDisPlayMode ?? .aspectFill))
                }
            } else {
                if !(self.localParticipant?.mic ?? false) {
                    self.stopPublishStream()
                }
                ZegoExpressEngine.shared().stopPreview()
            }
            for delegate in self.uikitEventDelegates.allObjects {
                guard let localParticipant = self.localParticipant else { return }
                delegate.onCameraOn?(localParticipant.toUserInfo(), isOn: isOn)
            }
        } else {
            // TODO: 第一期暂时不支持开关其他用户摄像头
        }
    }
    
    func setAudioConfig(_ config: ZegoAudioConfig) {
        ZegoExpressEngine.shared().setAudioConfig(config)
    }
    
    func setVideoConfig(_ config: ZegoVideoConfig) {
        ZegoExpressEngine.shared().setVideoConfig(config)
    }
    
    func setLocalVideoView(renderView: UIView, videoMode: ZegoUIKitVideoFillMode) {
//        guard let roomID = self.room?.roomID else {
//            print("Error: [setVideoView] You need to join the room first and then set the videoView")
//            return
//        }
        guard let userID = self.localParticipant?.userID else {
            print("Error: [setVideoView] please login room pre")
            return
        }
        
        let participant = participantDic[userID] ?? ZegoParticipant(userID: userID)
        if let roomID = self.room?.roomID {
            participant.streamID = generateStreamID(userID: userID, roomID: roomID)
            self.streamDic[participant.streamID] = participant.userID
        }
        participant.renderView = renderView
        participant.videoDisPlayMode = videoMode
        self.participantDic[userID] = participant
        ZegoExpressEngine.shared().startPreview(generateCanvas(rendView: renderView, videoMode: videoMode))
    }
    
    func setRemoteVideoView(userID: String, renderView: UIView, videoMode: ZegoUIKitVideoFillMode) {
        guard let roomID = self.room?.roomID else {
            print("Error: [setVideoView] You need to join the room first and then set the videoView")
            return
        }
        guard let localUserID = ZegoUIKit.shared.localUserInfo?.userID else {
            print("Error: [setVideoView] userID is empty, please enter a right userID")
            return
        }
        
        let participant = self.participantDic[userID] ?? ZegoParticipant(userID: userID)
        ZegoExpressEngine.shared().stopPlayingStream(participant.streamID)
        participant.streamID = generateStreamID(userID: userID, roomID: roomID)
        participant.renderView = renderView
        participant.videoDisPlayMode = videoMode
        self.participantDic[userID] = participant
        self.streamDic[participant.streamID] = participant.userID
        
        self.playStream(streamID: participant.streamID, videoModel: videoMode)
    }
    
    private func playStream(streamID: String, videoModel: ZegoUIKitVideoFillMode) {
        let userID: String? = streamDic[streamID]
        if let userID = userID {
            let participant: ZegoParticipant? = self.participantDic[userID]
            ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: generateCanvas(rendView: participant?.renderView, videoMode: videoModel))
            print("Error: [playStream] \(streamID)")
        }
    }
    
    private func generateCanvas(rendView: UIView?, videoMode: ZegoUIKitVideoFillMode) -> ZegoCanvas? {
        guard let rendView = rendView else {
            return nil
        }

        let canvas = ZegoCanvas(view: rendView)
        canvas.viewMode = .aspectFill
        return canvas
    }
    
    private func generateStreamID(userID: String, roomID: String) -> String {
        if (userID.count == 0) {
            print("Error: [generateStreamID] userID is empty, please enter a right userID")
        }
        if (roomID.count == 0) {
            print("Error: [generateStreamID] roomID is empty, please enter a right roomID")
        }
        
        // The streamID can use any character.
        // For the convenience of query, roomID + UserID + suffix is used here.
        let streamID = String(format: "%@_%@_main", roomID,userID)
        return streamID
    }
    
    private func startPublishStream() {
        guard let streamID = self.localParticipant?.streamID else { return }
        ZegoExpressEngine.shared().startPublishingStream(streamID)
    }
    
    private func stopPublishStream() {
        guard let streamID = self.localParticipant?.streamID else { return }
        ZegoExpressEngine.shared().stopPlayingStream(streamID)
        ZegoExpressEngine.shared().stopPreview()
    }
    
    private func isMySelf(_ userID: String) -> Bool {
        return userID == ZegoUIKit.shared.localUserInfo?.userID
    }
}

extension ZegoUIKitCore: ZegoEventHandler {
    
    func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
        var users = [ZegoUIkitUser]()
        for user in userList {
            if updateType == .add {
                let participant: ZegoParticipant = self.participantDic[user.userID] ?? ZegoParticipant.init(userID: user.userID, name: user.userName)
                participantDic[user.userID] = participant
                users.append(participant.toUserInfo())
            } else {
                let participant: ZegoParticipant? = self.participantDic[user.userID] ?? nil
                if let participant = participant {
                    ZegoExpressEngine.shared().stopPlayingStream(participant.streamID)
                    users.append(participant.toUserInfo())
                }
                participantDic.removeValue(forKey: user.userID)
            }
        }
        
        for delegate in self.uikitEventDelegates.allObjects {
            if updateType == .add {
                delegate.onRemoteUserJoin?(users)
            } else {
                delegate.onRemoteUserLeave?(users)
            }
        }
    }
    
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
        var userList = [ZegoUIkitUser]()
        for stream in streamList {
            if updateType == .add {
                self.streamDic[stream.streamID] = stream.user.userID
                var participant: ZegoParticipant? = self.participantDic[stream.user.userID]
                if let participant = participant {
                    participant.streamID = stream.streamID
                    participant.name = stream.user.userName
                    userList.append(participant.toUserInfo())
                } else {
                    participant = ZegoParticipant.init(userID: stream.user.userID, name: stream.user.userName)
                    participant?.streamID = stream.streamID
                    userList.append(participant!.toUserInfo())
                }
                self.participantDic[stream.user.userID] = participant
            } else {
                ZegoExpressEngine.shared().stopPlayingStream(stream.streamID)
                self.streamDic.removeValue(forKey: stream.streamID)
                let participant = self.participantDic[stream.user.userID]
                participant?.streamID = ""
                if let participant = participant {
                    self.participantDic[stream.user.userID] = participant
                    userList.append(participant.toUserInfo())
                }
            }
        }
        for delegate in self.uikitEventDelegates.allObjects {
            if updateType == .add {
                delegate.onAudioVideoAvailable?(userList)
            } else {
                delegate.onAudioVideoUnavailable?(userList)
            }
        }
    }
    
    func onRoomStateChanged(_ reason: ZegoRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable : Any], roomID: String) {
//        if self.room?.roomID == roomID {
//            self.room?.roomState = reason
//        }
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onRoomStateChanged?(ZegoUIKitRoomStateChangedReason(rawValue: reason.rawValue) ?? .logining, errorCode: errorCode, extendedData: extendedData, roomID: roomID)
        }
    }
    
    func onRemoteCameraStateUpdate(_ state: ZegoRemoteDeviceState, streamID: String) {
        for delegate in self.uikitEventDelegates.allObjects {
            if let user = participantDic[streamDic[streamID] ?? ""]?.toUserInfo() {
                if state == .open {
                    delegate.onCameraOn?(user, isOn: true)
                } else {
                    delegate.onCameraOn?(user, isOn: false)
                }
            }
        }
    }
    
    func onRemoteMicStateUpdate(_ state: ZegoRemoteDeviceState, streamID: String) {
        for delegate in self.uikitEventDelegates.allObjects {
            if let user = participantDic[streamDic[streamID] ?? ""]?.toUserInfo() {
                if state == .open {
                    delegate.onMicrophoneOn?(user, isOn: true)
                } else {
                    delegate.onMicrophoneOn?(user, isOn: false)
                }
            }
        }
    }
    
    func onAudioRouteChange(_ audioRoute: ZegoAudioRoute) {
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onAudioOutputDeviceChange?(ZegoUIKitAudioOutputDevice(rawValue: audioRoute.rawValue) ?? .speaker)
        }
    }
    
    func onRemoteSoundLevelUpdate(_ soundLevels: [String : NSNumber]) {
        for key in soundLevels.keys {
            guard let userID = self.streamDic[key] else { return }
            let user = self.participantDic[userID]?.toUserInfo()
            let value: Double = (soundLevels[key] ?? 0).doubleValue
            guard let user = user else { return }
            for delegate in self.uikitEventDelegates.allObjects {
                delegate.onSoundLevelUpdate?(user, level: value)
            }
        }
    }
    
    func onCapturedSoundLevelUpdate(_ soundLevel: NSNumber) {
        let user = self.localParticipant?.toUserInfo()
        guard let user = user else { return }
        for delegate in self.uikitEventDelegates.allObjects {
            delegate.onSoundLevelUpdate?(user, level: soundLevel.doubleValue)
        }
    }

    
}
