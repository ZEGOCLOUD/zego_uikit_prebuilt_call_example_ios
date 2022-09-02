//
//  CameraStatusIcon.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import UIKit
import ZegoExpressEngine

open class ZegoCameraStateIcon: UIImageView {
    
    
    public var userID: String? = ZegoUIKit.shared.localUserInfo?.userID
    public var iconCameraOn: UIImage? = ZegoUIIconSet.iconCameraStatusNomal
    public var iconCameraOff: UIImage? = ZegoUIIconSet.iconCameraStatusOff
    public var isOn: Bool = true {
        didSet {
            if isOn {
                self.image = iconCameraOn
            } else {
                self.image = iconCameraOff
            }
        }
    }
    
    private let help: CameraStatusIcon_Help = CameraStatusIcon_Help()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.help.cameraStatusIcon = self
        ZegoUIKit.shared.addEventHandler(self.help)
        self.isOn = true
        self.image = self.iconCameraOn
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class CameraStatusIcon_Help: NSObject, ZegoUIKitEventHandle {
    
    weak var cameraStatusIcon: ZegoCameraStateIcon?
    override init() {
        super.init()
        
    }
    
    func onCameraOn(_ user: ZegoUIkitUser, isOn: Bool) {
        if self.cameraStatusIcon?.userID == user.userID {
            self.cameraStatusIcon?.isOn = isOn
        }
    }
}
