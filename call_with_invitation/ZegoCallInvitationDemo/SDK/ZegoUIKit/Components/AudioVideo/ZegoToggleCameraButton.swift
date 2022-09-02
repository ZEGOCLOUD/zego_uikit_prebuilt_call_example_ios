//
//  ToggleCameraButton.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import UIKit

public protocol ZegoToggleCameraButtonDelegate: AnyObject {
    func onToggleCameraButtonClick(_ isOn: Bool)
}

extension ZegoToggleCameraButtonDelegate {
    func onToggleCameraButtonClick(_ isOn: Bool) { }
}


open class ZegoToggleCameraButton: UIButton {
    
    public weak var delegate: ZegoToggleCameraButtonDelegate?
    public var userID: String? = ZegoUIKit.shared.localUserInfo?.userID
    public var iconCameraOn: UIImage? {
        didSet {
            self.setImage(iconCameraOn, for: .selected)
        }
    }
    public var iconCameraOff: UIImage? {
        didSet {
            self.setImage(iconCameraOff, for: .normal)
        }
    }
    
    public var isOn: Bool = true {
        didSet {
            if isOn {
                self.isSelected = true
            } else {
                self.isSelected = false
            }
            guard let userID = self.userID else { return  }
            ZegoUIKit.shared.turnCameraOn(userID, isOn: isOn)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setImage(ZegoUIIconSet.iconCameraOn, for: .selected)
        self.setImage(ZegoUIIconSet.iconCameraOff, for: .normal)
        if let userID = userID,
           ZegoUIKit.shared.isCameraOn(userID)
        {
            self.isSelected = true
            self.isOn = true
        } else {
            self.isSelected = false
            self.isOn = false
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func buttonClick(sender: UIButton) {
        self.isOn = !self.isOn
        self.delegate?.onToggleCameraButtonClick(self.isOn)
    }
}

