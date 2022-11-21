//
//  ViewController.swift
//  ZegoUIKitCallWithInvitationDemo
//
//  Created by zego on 2022/10/20.
//

import UIKit
import ZegoUIKitSDK
import Toast_Swift
import ZegoUIKitSignalingPlugin
import ZegoUIKitPrebuiltCall

class ViewController: UIViewController {
    
    let appID: UInt32 = <#YourAppID#>
    let appSign: String = <#YourAppSign#>
    
    let selfUserID: String = String(format: "%d", Int.random(in: 0...99999))
    
    @IBOutlet weak var voiceCallView: UIView! {
        didSet {
            voiceCallButton.frame = CGRect(x: 0, y: 0, width: voiceCallView.bounds.size.width, height: voiceCallView.bounds.size.height)
            voiceCallButton.delegate = self
            voiceCallView.addSubview(voiceCallButton)
        }
    }
    
    @IBOutlet weak var videoCallView: UIView! {
        didSet {
            videoCallButton.frame = CGRect(x: 0, y: 0, width: videoCallView.bounds.size.width, height: videoCallView.bounds.size.height)
            videoCallButton.delegate = self
            videoCallView.addSubview(videoCallButton)
        }
    }
    
    @IBOutlet weak var inviteesTextField: UITextField! {
        didSet {
            inviteesTextField.delegate = self
            inviteesTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        }
    }
    
    
    @IBOutlet weak var yourUserIDLabel: UILabel! {
        didSet {
            yourUserIDLabel.text = String(format: "Your UserID:%@", selfUserID)
        }
    }
    
    let voiceCallButton: ZegoStartCallInvitationButton = ZegoStartCallInvitationButton(ZegoInvitationType.voiceCall.rawValue)
    let videoCallButton: ZegoStartCallInvitationButton = ZegoStartCallInvitationButton(ZegoInvitationType.videoCall.rawValue)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userName: String = selfUserID
        let config = ZegoUIKitPrebuiltCallInvitationConfig([ZegoUIKitSignalingPlugin()])
        ZegoUIKitPrebuiltCallInvitationService.shared.initWithAppID(self.appID, appSign: self.appSign, userID: selfUserID, userName: userName, config: config)
        ZegoUIKitPrebuiltCallInvitationService.shared.delegate = self
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        guard let userIDString = textField.text else { return }
        let userIDList = userIDString.components(separatedBy: ",")
        var inviteesList: [ZegoUIKitUser] = []
        for userID in userIDList {
            let userName: String = String(format: "%@", userID)
            if userID == "" {
                continue
            }
            let user: ZegoUIKitUser = ZegoUIKitUser.init(userID, userName)
            inviteesList.append(user)
        }
        self.voiceCallButton.inviteeList = inviteesList
        self.videoCallButton.inviteeList = inviteesList
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inviteesTextField.endEditing(true)
    }
    
}

extension ViewController: ZegoUIKitPrebuiltCallInvitationServiceDelegate, UITextFieldDelegate, ZegoStartInvitationButtonDelegate {
    //MARK: -ZegoUIKitPrebuiltCallInvitationServiceDelegate
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIKitPrebuiltCallConfig {
        if data.type == .voiceCall {
            if data.invitees?.count ?? 0 > 1 {
                let config = ZegoUIKitPrebuiltCallConfig(.groupVoiceCall)
                return config
            } else {
                let config = ZegoUIKitPrebuiltCallConfig(.oneOnOneVoiceCall)
                return config
            }
        } else {
            if data.invitees?.count ?? 0 > 1 {
                let config = ZegoUIKitPrebuiltCallConfig(.groupVideoCall)
                return config
            } else {
                let config = ZegoUIKitPrebuiltCallConfig(.oneOnOneVideoCall)
                return config
            }
        }
    }
    
    //MARK: -ZegoStartInvitationButtonDelegate
    func onStartInvitationButtonClick(_ data: [String : AnyObject]?) {
        guard let data = data else {
            return
        }
        let code: Int = data["code"] as! Int
        let message: String? = data["message"] as? String
        var toastMessage: String?
        if code != 0 {
            toastMessage = String(format: "Failed to send a call invitation. code: %d,message:%@",code, message ?? "")
            self.view.makeToast(toastMessage, duration: 2.0, position: .center)
        } else {
            let errorInvitees: [String]? = data["errorInvitees"] as? [String]
            guard let errorInvitees = errorInvitees else { return }
            var errorUsers: String = ""
            var index: Int = 0
            for userID in errorInvitees {
                if index > 4 {
                    errorUsers.append(contentsOf: "...")
                    break
                }
                if index == 0 {
                    errorUsers.append(contentsOf: String(format: "%@", userID))
                } else {
                    errorUsers.append(contentsOf: String(format: ",%@", userID))
                }
                index = index + 1
            }
            toastMessage = String(format: "User doesn't exist or is offline: %@", errorUsers)
            if errorInvitees.count > 0 {
                getCurrentViewController()?.view.makeToast(toastMessage, duration: 2.0, position: .center)
            }
        }
    }
    
    func getCurrentViewController() -> (UIViewController?) {
       var window = UIApplication.shared.keyWindow
       if window?.windowLevel != UIWindow.Level.normal{
         let windows = UIApplication.shared.windows
         for  windowTemp in windows{
           if windowTemp.windowLevel == UIWindow.Level.normal{
              window = windowTemp
              break
            }
          }
        }
       let vc = window?.rootViewController
       return vc
    }
}



