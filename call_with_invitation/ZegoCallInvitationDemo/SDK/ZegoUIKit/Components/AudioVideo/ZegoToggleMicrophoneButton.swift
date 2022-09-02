//
//  ToggleMicButton.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import UIKit

public protocol ToggleMicrophoneButtonDelegate: AnyObject {
    func onToggleMicButtonClick(_ isOn: Bool)
}

extension ToggleMicrophoneButtonDelegate {
    func onToggleMicButtonClick(_ isOn: Bool) { }
}

open class ZegoToggleMicrophoneButton: UIButton {
    
    public var userID: String? = ZegoUIKit.shared.localUserInfo?.userID
    public var isOn: Bool = true {
        didSet {
            self.isSelected = !isOn
            guard let userID = self.userID else {
                return
            }
            ZegoUIKit.shared.turnMicrophoneOn(userID, isOn: isOn)
        }
    }
    public weak var delegate: ToggleMicrophoneButtonDelegate?
    
    var iconMicrophoneOn: UIImage? = ZegoUIIconSet.iconMicNormal {
        didSet {
            self.setImage(iconMicrophoneOn, for: .normal)
        }
    }
    var iconMicrophoneOff: UIImage? = ZegoUIIconSet.iconMicOff {
        didSet {
            self.setImage(iconMicrophoneOff, for: .selected)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setImage(self.iconMicrophoneOn, for: .normal)
        self.setImage(self.iconMicrophoneOff, for: .selected)
        if let userID = userID,
           ZegoUIKit.shared.isCameraOn(userID)
        {
            self.isSelected = false
            self.isOn = true
        } else {
            self.isSelected = true
            self.isOn = false
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClick() {
        self.isOn = !self.isOn
        self.delegate?.onToggleMicButtonClick(self.isOn)
    }

}
