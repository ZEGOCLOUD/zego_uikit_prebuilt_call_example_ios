//
//  ViewController.swift
//  ZegoCallInvitationDemo
//
//  Created by zego on 2022/8/16.
//

import UIKit
import ZegoUIKitSDK

class ViewController: UIViewController {
    
    var selfUserID: String?
    var selfUserName: String?
    
    var startVoiceCallButton: ZegoStartCallInvitationButton?
    var startVideoCallButton: ZegoStartCallInvitationButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Init SDK
        self.selfUserID = String(format: "%d", Int.random(in: 0...99999))
        guard let userID = self.selfUserID else { return }
        self.selfUserName = String(format: "xh_%@", userID)
        
        let config = ZegoUIkitPrebuiltCallConfig()
        config.menuBarButtons = []
        ZegoUIKitPrebuiltCallInvitationService.shared.initWithAppID(3630571287, appSign: "12a16a0cca137778fa220bf84b8af7b82ae75cddd85d7e9ca3de01d240ab1a05", userID: userID, userName: selfUserName!)
        ZegoUIKitPrebuiltCallInvitationService.shared.delegate = self
        
        
        let label: UILabel = UILabel()
        label.frame = CGRect.init(x: 100, y: 50, width: 200, height: 20)
        label.text = String(format: "selfUserID: %@", userID)
        self.view.addSubview(label)
        
        
        let textField: UITextField = UITextField()
        textField.borderStyle = .roundedRect
        textField.frame = CGRect.init(x: 100, y: 80, width: 250, height: 30)
        textField.placeholder = "please input target user id"
        self.view.addSubview(textField)
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        // Create Voice Call invitation Button
        startVoiceCallButton = ZegoStartCallInvitationButton.init(.voiceCall)
        startVoiceCallButton?.backgroundColor = UIColor.gray
        startVoiceCallButton?.setTitleColor(UIColor.blue, for: .normal)
        startVoiceCallButton?.frame = CGRect.init(x: 100, y: 120, width: 150, height: 40)
        self.view.addSubview(startVoiceCallButton!)
        
        startVideoCallButton = ZegoStartCallInvitationButton.init(.videoCall)
        startVideoCallButton?.isVideoCall = true
        startVideoCallButton?.backgroundColor = UIColor.gray
        startVideoCallButton?.setTitleColor(UIColor.blue, for: .normal)
        startVideoCallButton?.frame = CGRect.init(x: 100, y: 200, width: 150, height: 40)
        self.view.addSubview(startVideoCallButton!)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        guard let userID = textField.text else { return }
        let userName: String = String(format: "xh_%@", userID)
        let user: ZegoUIkitUser = ZegoUIkitUser.init(userID, userName)
        self.startVoiceCallButton?.inviteeList = [user]
        self.startVideoCallButton?.inviteeList = [user]
    }
    
}

extension ViewController : ZegoUIKitPrebuiltCallInvitationServiceDelegate {
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIkitPrebuiltCallConfig {
        if data.type == .voiceCall {
            let config = ZegoUIkitPrebuiltCallConfig()
            config.turnOnCameraWhenjoining = false
            config.menuBarButtons = [.toggleMicrophoneButton,.quitButton,.swtichAudioOutputButton]
            return config
        } else {
            let config = ZegoUIkitPrebuiltCallConfig()
            return config
        }
    }
}

