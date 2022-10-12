//
//  ViewController.swift
//  ZegoUIKitCallInviteExample
//
//  Created by zego on 2022/8/8.
//

import UIKit
import ZegoUIKitSDK
import ZegoUIKitPrebuiltCall

class ViewController: UIViewController {
    
    let appID: UInt32 = <#YourAppID#>
    let appSign: String = <#YourAppSign#>

    @IBOutlet weak var userIdLabel: UILabel! {
        didSet {
            userIdLabel.text = String(format: "Your User ID:%@", selfUserID ?? "")
        }
    }
    
    @IBOutlet weak var userIDTextField: UILabel! {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var callIDTextField: UITextField! {
        didSet {
            callIDTextField.text = self.nomalCallID
            callIDTextField.tag = 101
            callIDTextField.layer.borderWidth = 1.0
            callIDTextField.layer.borderColor = UIColor.colorWithHexString("#333333").cgColor
            callIDTextField.layer.masksToBounds = true
            callIDTextField.layer.cornerRadius = 9.0
            callIDTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            callIDTextField.addTarget(self, action: #selector(textDidBegine(_:)), for: .editingDidBegin)
            callIDTextField.addTarget(self, action: #selector(textDidEnd(_:)), for: .editingDidEnd)
        }
    }
    
    @IBOutlet weak var inviteeTextField: UITextField! {
        didSet {
            inviteeTextField.tag = 102
            inviteeTextField.layer.borderWidth = 1.0
            inviteeTextField.layer.borderColor = UIColor.colorWithHexString("#333333").cgColor
            inviteeTextField.layer.masksToBounds = true
            inviteeTextField.layer.cornerRadius = 9.0
            inviteeTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            inviteeTextField.addTarget(self, action: #selector(textDidBegine(_:)), for: .editingDidBegin)
            inviteeTextField.addTarget(self, action: #selector(textDidEnd(_:)), for: .editingDidEnd)
        }
    }
    
    @IBOutlet weak var oneOnOneVoiceButton: UIButton! {
        didSet {
            oneOnOneVoiceButton.layer.masksToBounds = true
            oneOnOneVoiceButton.layer.cornerRadius = 9.0
        }
    }
    
    @IBOutlet weak var oneOnOneVideoButton: UIButton! {
        didSet {
            oneOnOneVideoButton.layer.masksToBounds = true
            oneOnOneVideoButton.layer.cornerRadius = 9.0
        }
    }
    
    
    @IBOutlet weak var voiceCallView: UIView! {
        didSet {
            let callButton = ZegoStartCallInvitationButton(.voiceCall)
            callButton.frame = CGRect(x: 0, y: 0, width: voiceCallView.bounds.size.width, height: voiceCallView.bounds.size.height)
            self.voiceCallButton = callButton
            voiceCallView.addSubview(callButton)
        }
    }
    
    @IBOutlet weak var videoCallView: UIView! {
        didSet {
            let callButton = ZegoStartCallInvitationButton(.videoCall)
            callButton.frame = CGRect(x: 0, y: 0, width: videoCallView.bounds.size.width, height: videoCallView.bounds.size.height)
            self.videoCallButton = callButton
            videoCallView.addSubview(callButton)
        }
    }
    
    var voiceCallButton: ZegoStartCallInvitationButton! {
        didSet {
            voiceCallButton.setImage(UIImage.init(named: "icon_iphone_un"), for: .normal)
            voiceCallButton.layer.masksToBounds = true
            voiceCallButton.layer.cornerRadius = 9.0
            voiceCallButton.setTitle("Voice call", for: .normal)
            voiceCallButton.setTitleColor(UIColor.colorWithHexString("#656667"), for: .normal)
        }
    }
    
    var videoCallButton: ZegoStartCallInvitationButton! {
        didSet {
            videoCallButton.setImage(UIImage.init(named: "icon_camera_un"), for: .normal)
            videoCallButton.setImage(UIImage.init(named: "icon_camera_normal"), for: .highlighted)
            videoCallButton.layer.masksToBounds = true
            videoCallButton.layer.cornerRadius = 9.0
            videoCallButton.setTitle("Video call", for: .normal)
            videoCallButton.setTitleColor(UIColor.colorWithHexString("#656667"), for: .normal)
        }
    }

    
    var selfUserID: String?
    var selfUserName: String?
    var nomalCallID: String = String(format: "%d", Int.random(in: 0...9999))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.selfUserID = String(format: "%d", Int.random(in: 0...99999))
        guard let userID = self.selfUserID else { return }
        self.selfUserName = String(format: "xh_%@", userID)
        ZegoUIKitPrebuiltCallInvitationService.shared.initWithAppID(self.appID, appSign: self.appSign, userID: userID, userName: self.selfUserName ?? "")
        ZegoUIKitPrebuiltCallInvitationService.shared.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func VoiceCall(_ sender: Any) {
        guard let userID = self.selfUserID else { return }
        guard let callID = self.callIDTextField.text else { return }
        if callID.count == 0 { return }
        let config = ZegoUIKitPrebuiltCallConfig(.oneOnOneVoiceCall)
        let audioVideoConfig = ZegoPrebuiltAudioVideoViewConfig()
        audioVideoConfig.showCameraStateOnView = false
        config.audioVideoViewConfig = audioVideoConfig
        config.hangUpConfirmDialogInfo = ZegoLeaveConfirmDialogInfo()
        let userName: String = String(format: "Z_iOS_%@", userID)
        let callVC = ZegoUIKitPrebuiltCallVC.init(self.appID, appSign: self.appSign, userID: userID, userName: userName, callID: callID, config: config)
        callVC.modalPresentationStyle = .fullScreen
        self.present(callVC, animated: true, completion: nil)
    }
    

    @IBAction func VideoCall(_ sender: Any) {
        guard let userID = self.selfUserID else { return }
        guard let callID = self.callIDTextField.text else { return }
        if callID.count == 0 { return }
        let config = ZegoUIKitPrebuiltCallConfig(.oneOnOneVideoCall)
        let audioVideoConfig = ZegoPrebuiltAudioVideoViewConfig()
        audioVideoConfig.showCameraStateOnView = false
        config.audioVideoViewConfig = audioVideoConfig
        let dialog = ZegoLeaveConfirmDialogInfo()
        dialog.title = "Leave the room"
        dialog.message = "Are you sure to leave the room?"
        dialog.cancelButtonName = "Cancel"
        dialog.confirmButtonName = "Confirm"
        config.hangUpConfirmDialogInfo = ZegoLeaveConfirmDialogInfo()
        let userName: String = String(format: "Z_iOS_%@", userID)
        let callVC = ZegoUIKitPrebuiltCallVC.init(self.appID, appSign: self.appSign, userID: userID, userName: userName, callID: callID, config: config)
        dialog.dialogPresentVC = callVC
        callVC.modalPresentationStyle = .fullScreen
        self.present(callVC, animated: true, completion: nil)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if textField.tag == 101 {
            if textField.text?.count ?? 0 > 0 {
                self.oneOnOneVoiceButton.setTitleColor(UIColor.colorWithHexString("#0055FF"), for: .normal)
                self.oneOnOneVoiceButton.backgroundColor = UIColor.colorWithHexString("#0055FF", alpha: 0.04)
                self.oneOnOneVideoButton.setTitleColor(UIColor.colorWithHexString("#0055FF"), for: .normal)
                self.oneOnOneVideoButton.backgroundColor = UIColor.colorWithHexString("#0055FF", alpha: 0.04)
            } else {
                self.oneOnOneVoiceButton.setTitleColor(UIColor.colorWithHexString("#656667"), for: .normal)
                self.oneOnOneVoiceButton.backgroundColor = UIColor.colorWithHexString("#F4F7FB", alpha: 1.0)
                self.oneOnOneVideoButton.setTitleColor(UIColor.colorWithHexString("#656667"), for: .normal)
                self.oneOnOneVideoButton.backgroundColor = UIColor.colorWithHexString("#F4F7FB", alpha: 1.0)
            }
        } else if textField.tag == 102 {
            if textField.text?.count ?? 0 > 0 {
                self.voiceCallButton.setImage(UIImage.init(named: "icon_iphone_normal"), for: .normal)
                self.voiceCallButton.setTitleColor(UIColor.colorWithHexString("#0055FF"), for: .normal)
                self.voiceCallButton.backgroundColor = UIColor.colorWithHexString("#0055FF", alpha: 0.04)
                self.videoCallButton.setImage(UIImage.init(named: "icon_camera_normal"), for: .normal)
                self.videoCallButton.setTitleColor(UIColor.colorWithHexString("#0055FF"), for: .normal)
                self.videoCallButton.backgroundColor = UIColor.colorWithHexString("#0055FF", alpha: 0.04)
            } else {
                self.voiceCallButton.setImage(UIImage.init(named: "icon_iphone_un"), for: .normal)
                self.voiceCallButton.setTitleColor(UIColor.colorWithHexString("#656667"), for: .normal)
                self.voiceCallButton.backgroundColor = UIColor.colorWithHexString("#F4F7FB", alpha: 1.0)
                self.videoCallButton.setImage(UIImage.init(named: "icon_camera_un"), for: .normal)
                self.videoCallButton.setTitleColor(UIColor.colorWithHexString("#656667"), for: .normal)
                self.videoCallButton.backgroundColor = UIColor.colorWithHexString("#F4F7FB", alpha: 1.0)
            }
            guard let userID = textField.text else { return }
            let userName: String = String(format: "Z_iOS_%@", userID)
            let user: ZegoUIkitUser = ZegoUIkitUser.init(userID, userName)
            self.voiceCallButton.inviteeList = [user]
            self.videoCallButton.inviteeList = [user]
        }
    }
    
    @objc func textDidBegine(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.colorWithHexString("#0055FF").cgColor
        textField.textColor = UIColor.colorWithHexString("#0055FF")
    }
    
    @objc func textDidEnd(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.colorWithHexString("#333333").cgColor
        textField.textColor = UIColor.colorWithHexString("#2A2A2A")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
}

extension ViewController: ZegoUIKitPrebuiltCallInvitationServiceDelegate {
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIKitPrebuiltCallConfig {
        if data.type == .voiceCall {
            let config = ZegoUIKitPrebuiltCallConfig(.oneOnOneVoiceCall)
            return config
        } else {
            let config = ZegoUIKitPrebuiltCallConfig(.oneOnOneVideoCall)
            return config
        }
    }
}

