//
//  ZegoAcceptInvitationButton.swift
//  ZegoUIKit
//
//  Created by zego on 2022/8/9.
//

import UIKit

public protocol ZegoAcceptInvitationButtonDelegate: AnyObject{
    func onAcceptInvitationButtonClick()
}

extension ZegoAcceptInvitationButtonDelegate {
    func onAcceptInvitationButtonClick() { }
}

open class ZegoAcceptInvitationButton: UIButton {

    public var icon: UIImage = ZegoUIIconSet.iconCallAccept {
        didSet {
            self.setImage(self.icon, for: .normal)
        }
    }
    public var text: String? {
        didSet {
            self.setTitle(text, for: .normal)
        }
    }
    public weak var delegate: ZegoAcceptInvitationButtonDelegate?
    public var inviterID: String?
    
    public init(_ inviterID: String) {
        super.init(frame: CGRect.zero)
        self.inviterID = inviterID
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setImage(icon, for: .normal)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setImage(icon, for: .normal)
    }
    
    @objc func buttonClick() {
        guard let inviterID = inviterID else { return }
        ZegoUIKit.shared.acceptInvitation(inviterID, data: nil)
        self.delegate?.onAcceptInvitationButtonClick()
    }

}
