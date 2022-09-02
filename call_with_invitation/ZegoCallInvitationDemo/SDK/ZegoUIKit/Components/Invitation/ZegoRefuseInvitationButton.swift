//
//  ZegoRejectInvitationButton.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/9.
//

import UIKit

public protocol ZegoRefuseInvitationButtonDelegate: AnyObject {
    func onRefuseInvitationButtonClick()
}

extension ZegoRefuseInvitationButtonDelegate {
    func onRefuseInvitationButtonClick() { }
}

open class ZegoRefuseInvitationButton: UIButton {
    
    public var icon: UIImage = ZegoUIIconSet.iconCallDecline {
        didSet {
            self.setImage(self.icon, for: .normal)
        }
    }
    public var text: String? {
        didSet {
            self.setTitle(text, for: .normal)
        }
    }
    public weak var delegate: ZegoRefuseInvitationButtonDelegate?
    
    public var inviterID: String?

    public init(_ inviterID: String) {
        super.init(frame: CGRect.zero)
        self.inviterID = inviterID
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setImage(self.icon, for: .normal)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setImage(self.icon, for: .normal)
    }

    @objc func buttonClick() {
        guard let inviterID = inviterID else { return }
        ZegoUIKit.shared.refuseInvitation(inviterID, data: nil)
        self.delegate?.onRefuseInvitationButtonClick()
    }
}
