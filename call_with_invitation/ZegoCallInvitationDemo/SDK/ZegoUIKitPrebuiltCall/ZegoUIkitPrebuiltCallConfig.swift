//
//  Prebuilt1on1Config.swift
//  ZegoUIKitExample
//
//  Created by zego on 2022/7/14.
//

import UIKit
import ZegoUIKitSDK

public class ZegoUIkitPrebuiltCallConfig: NSObject {
    /// 用于控制是否在VideoView上显示prebuilt层默认的MicrophoneStateIcon
    public var showMicrophoneStateOnView: Bool = true
    /// 用于控制是否在VideoView上显示prebuilt层默认的CameraStateIcon
    public var showCameraStateOnView: Bool = true
    /// 用于控制是否在VideoView上显示prebuilt层默认的UserNameLabel
    public var showUserNameOnView: Bool = true
    ///
    public var layout: ZegoLayout = ZegoLayout()
    /// 是否默认开启摄像头，默认为开。
    public var turnOnCameraWhenjoining: Bool = true
    /// 是否默认开启麦克风，默认为开。
    public var turnOnMicrophoneWhenjoining: Bool = true
    /// 是否默认使用扬声器，默认为是。如果否，使用系统默认设备。
    public var useSpeakerWhenjoining: Bool = false
    /// 在ControlBar最多能显示的按钮数量，如果超过了该值，则显示“更多”按钮
    public var menuBarButtons: [ZegoMenuBarButtonType] = [.toggleCameraButton,.toggleMicrophoneButton,.quitButton,.swtichAudioOutputButton,.swtichCameraFacingButton]
    /// 在ControlBar最多能显示的按钮数量，如果超过了该值，则显示“更多”按钮在ControlBar最多能显示的按钮数量，如果超过了该值，则显示“更多”按钮,该值最大为5,注意这个值是包含“更多”按钮
    public var menuBarButtonsMaxCount: Int = 5
    /// 是否屏幕无操作5秒后，或用户点击屏幕无响应区位置，顶部、底部收起
    public var hideMenuBarAutomatically: Bool = true
    /// 是否可以点击无响应区域主动隐藏
    public var hideMenuBardByClick: Bool = true
    /// 点击挂断按钮时是否显示离开房间对话框的信息。不设置就不显示，设置了就会显示。
    public var hangUpConfirmDialogInfo: ZegoLeaveConfirmDialogInfo?
    ///默认false，普通黑边模式（否则横屏很难看）
    /// if set to true, video view will proportional zoom fills the entire View and may be partially cut
    /// if set to false, video view proportional scaling up, there may be black borders
    public var useVideoViewAspectFill: Bool = false
}

public class ZegoLayout: NSObject {
    public var mode: ZegoUIKitLayoutMode = .pictureInPicture
    public var config: ZegoLayoutConfig = ZegoLayoutPictureInPictureConfig()
}


