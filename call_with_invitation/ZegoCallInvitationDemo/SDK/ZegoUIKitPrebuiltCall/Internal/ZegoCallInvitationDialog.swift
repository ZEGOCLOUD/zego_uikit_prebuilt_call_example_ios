//
//  CallAcceptTipView.swift
//  ZEGOCallDemo
//
//  Created by zego on 2022/1/12.
//

import UIKit
import ZegoUIKitSDK

protocol CallAcceptTipViewDelegate: AnyObject {
//    func tipViewDeclineCall(_ userInfo: UserInfo, callType: CallType)
//    func tipViewAcceptCall(_ userInfo: UserInfo, callType: CallType)
//    func tipViewDidClik(_ userInfo: UserInfo, callType: CallType)
}

class ZegoCallInvitationDialog: UIView {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var acceptButton: ZegoAcceptInvitationButton! {
        didSet {
            acceptButton.delegate = self
        }
    }
    
    @IBOutlet weak var refuseButton: ZegoRefuseInvitationButton! {
        didSet {
            refuseButton.delegate = self
        }
    }
    
    
    @IBOutlet weak var headLabel: UILabel! {
        didSet {
            headLabel.layer.masksToBounds = true
            headLabel.layer.cornerRadius = 21
            headLabel.textAlignment = .center
        }
    }
    
    weak var delegate: CallAcceptTipViewDelegate?
    private var invitationData: ZegoCallInvitationData? {
        didSet {
            self.acceptButton.inviterID = invitationData?.inviter?.userID
            self.refuseButton.inviterID = invitationData?.inviter?.userID
        }
    }
    
    private var type: ZegoInvitationType = .voiceCall
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        let tapClick: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(viewTap))
        self.addGestureRecognizer(tapClick)
    }
    
    public static func show(_ callInvitationData: ZegoCallInvitationData) -> ZegoCallInvitationDialog {
        return showTipView(callInvitationData)
    }
    
    private static func showTipView(_ callInvitationData: ZegoCallInvitationData) -> ZegoCallInvitationDialog {
        let tipView: ZegoCallInvitationDialog = UINib(nibName: "ZegoCallInvitationDialog", bundle: Bundle(for: ZegoCallInvitationData.self)).instantiate(withOwner: nil, options: nil).first as! ZegoCallInvitationDialog
        let y = KeyWindow().safeAreaInsets.top
        tipView.frame = CGRect.init(x: 8, y: y + 8, width: UIScreen.main.bounds.size.width - 16, height: 80)
        tipView.invitationData = callInvitationData
        tipView.layer.masksToBounds = true
        tipView.layer.cornerRadius = 8
        tipView.type = callInvitationData.type ?? .voiceCall
        tipView.setHeadUserName(callInvitationData.inviter?.userName)
        tipView.userNameLabel.text = callInvitationData.inviter?.userName
        switch callInvitationData.type {
        case .voiceCall:
            tipView.messageLabel.text = "Voice Call"
            tipView.acceptButton.icon = ZegoUIKitCallIconSetType.call_accept_icon.load()
        case .videoCall:
            tipView.messageLabel.text = "Video Call"
            tipView.acceptButton.icon  = ZegoUIKitCallIconSetType.call_video_icon.load()
        case .none:
            break
        }
        tipView.showTip()
        return tipView
    }
    
    private func setHeadUserName(_ userName: String?) {
        guard let userName = userName else { return }
        if userName.count > 0 {
            let firstStr: String = String(userName[userName.startIndex])
            self.headLabel.text = firstStr
        }
    }
        
    public static func hide() {
        DispatchQueue.main.async {
            for subview in KeyWindow().subviews {
                if subview is ZegoCallInvitationDialog {
                    let view: ZegoCallInvitationDialog = subview as! ZegoCallInvitationDialog
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    private func showTip()  {
        KeyWindow().addSubview(self)
    }
    
    @objc func viewTap() {
        let vc = UINib.init(nibName: "ZegoUIKitPrebuiltCallWaitingVC", bundle: Bundle(for: ZegoUIKitPrebuiltCallWaitingVC.self)).instantiate(withOwner: nil, options: nil).first as! ZegoUIKitPrebuiltCallWaitingVC
        vc.isInviter = false
        vc.callInvitationData = self.invitationData
        vc.modalPresentationStyle = .fullScreen
        currentViewController()?.present(vc, animated: true, completion: nil)
        ZegoCallInvitationDialog.hide()
    }
    
}

extension ZegoCallInvitationDialog: ZegoAcceptInvitationButtonDelegate {
    public func onAcceptInvitationButtonClick() {
        guard let invitationData = invitationData else {
            return
        }
        let config = ZegoUIKitPrebuiltCallInvitationService.shared.delegate?.requireConfig(invitationData)
        let callVC: ZegoUIKitPrebuiltCallVC = ZegoUIKitPrebuiltCallVC.init(invitationData, config: config)
        callVC.modalPresentationStyle = .fullScreen
        callVC.delegate = ZegoUIKitPrebuiltCallInvitationService.shared.help
        currentViewController()?.present(callVC, animated: true, completion: nil)
        ZegoCallInvitationDialog.hide()
    }
}

extension ZegoCallInvitationDialog: ZegoRefuseInvitationButtonDelegate {
    func onRefuseInvitationButtonClick() {
        ZegoUIKitPrebuiltCallInvitationService.shared.isCalling = false
        ZegoCallInvitationDialog.hide()
    }
}
