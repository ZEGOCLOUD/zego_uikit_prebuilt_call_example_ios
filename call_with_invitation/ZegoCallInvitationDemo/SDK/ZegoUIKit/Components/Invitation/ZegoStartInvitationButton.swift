//
//  ZegoStartInvitationButton.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/9.
//

import UIKit

public protocol ZegoStartInvitationButtonDelegate: AnyObject{
    func onStartInvitationButtonClick()
}

extension ZegoStartInvitationButtonDelegate {
    func onStartInvitationButtonClick() { }
}

open class ZegoStartInvitationButton: UIButton {

    public var icon: UIImage? {
        didSet {
            guard let icon = icon else {
                return
            }
            self.setImage(icon, for: .normal)
        }
    }
    public var text: String? {
        didSet {
            self.setTitle(text, for: .normal)
        }
    }
    public var invitees: [String] = []
    public var data: String?
    public var timeout: UInt32 = 60
    public var type: Int = 0
    public weak var delegate: ZegoStartInvitationButtonDelegate?

    public init(_ type: ZegoInvitationType) {
        super.init(frame: CGRect.zero)
        if type == .voiceCall {
            self.setImage(ZegoUIIconSet.iconUsePhone, for: .normal)
        } else {
            self.setImage(ZegoUIIconSet.iconUseVideo, for: .normal)
        }
        self.type = type.rawValue
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    @objc func buttonClick() {
        if invitees.count == 0 {
            return
        }
        ZegoUIKit.shared.startInvitation(self.invitees, timeout: self.timeout, type: self.type, data: self.data)
        self.delegate?.onStartInvitationButtonClick()
    }
    
}
