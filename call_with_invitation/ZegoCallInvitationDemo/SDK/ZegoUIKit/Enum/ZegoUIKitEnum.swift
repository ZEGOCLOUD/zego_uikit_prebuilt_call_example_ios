//
//  UIKitEnum.swift
//  ZegoUIKitExample
//
//  Created by zego on 2022/7/14.
//

import Foundation
import ZegoExpressEngine

public enum ZegoUIKitVideoFillMode: UInt {
    /// The proportional scaling up, there may be black borders
    case aspectFit = 0
    /// The proportional zoom fills the entire View and may be partially cut
    case aspectFill = 1
    /// Fill the entire view, the image may be stretched
    case scaleToFill = 2
}

public enum ZegoUIKitLayoutMode: UInt {
    case pictureInPicture = 0
}

@objc public enum ZegoUIKitRoomStateChangedReason: UInt {
    /// Logging in to the room. When calling [loginRoom] to log in to the room or [switchRoom] to switch to the target room, it will enter this state, indicating that it is requesting to connect to the server. The application interface is usually displayed through this state.
    case logining = 0
    /// Log in to the room successfully. When the room is successfully logged in or switched, it will enter this state, indicating that the login to the room has been successful, and users can normally receive callback notifications of other users in the room and all stream information additions and deletions.
    case logined = 1
    /// Failed to log in to the room. When the login or switch room fails, it will enter this state, indicating that the login or switch room has failed, for example, AppID or Token is incorrect, etc.
    case loginFailed = 2
    /// The room connection is temporarily interrupted. If the interruption occurs due to poor network quality, the SDK will retry internally.
    case reconnecting = 3
    /// The room is successfully reconnected. If there is an interruption due to poor network quality, the SDK will retry internally, and enter this state after successful reconnection.
    case reconnected = 4
    /// The room fails to reconnect. If there is an interruption due to poor network quality, the SDK will retry internally, and enter this state after the reconnection fails.
    case reconnectFailed = 5
    /// Kicked out of the room by the server. For example, if you log in to the room with the same user name in other places, and the local end is kicked out of the room, it will enter this state.
    case kickOut = 6
    /// Logout of the room is successful. It is in this state by default before logging into the room. When calling [logoutRoom] to log out of the room successfully or [switchRoom] to log out of the current room successfully, it will enter this state.
    case logout = 7
    /// Failed to log out of the room. Enter this state when calling [logoutRoom] fails to log out of the room or [switchRoom] fails to log out of the current room internally.
    case logoutFailed = 8
}

/// Audio route
@objc public enum ZegoUIKitAudioOutputDevice: UInt {
    /// Speaker
    case speaker = 0
    /// Headphone
    case headphone = 1
    /// Bluetooth device
    case bluetooth = 2
    /// Receiver
    case earSpeaker = 3
    /// External USB audio device
    case externalUSB = 4
    /// Apple AirPlay
    case airPlay = 5
}

public enum ZegoInvitationType: Int {
    case voiceCall = 0
    case videoCall = 1
}


enum ZegoUIIconSetType: String, Hashable {
    case icon_camera_normal
    case icon_camera_off
    case icon_mic_normal
    case icon_mic_off
    case icon_speaker_normal
    case icon_speaker_off
    case icon_iphone
    case icon_more
    case icon_camera_flip
    case icon_bluetooth
    case icon_mic_status_wave
    case icon_mic_status_off
    case icon_mic_status_nomal
    case icon_wifi
    case icon_camera_status_nomal
    case icon_camera_status_off
    
    case icon_camera_normal_2
    case icon_camera_off_2
    
    case icon_camera_overturn_2
    
    case camera_normal_2
    case camera_off_2
    
    case call_accept_icon
    case call_accept_selected_icon
    case call_accept_loading
    case call_decline_icon
    case call_decline_selected_icon
    case call_video_icon
    case call_video_selected_icon
    case call_hand_up_icon
    case call_hand_up_selected_icon
    
    case user_phone_icon
    case user_video_icon
    
    // MARK: - Image handling
    
    private static let bundle = Bundle(identifier: bundleIdentifier)
    
    func load() -> UIImage {
        let image = UIImage(named: self.rawValue, in: ZegoUIIconSetType.bundle, compatibleWith: nil)!
        return image
    }
}
