//
//  ViewController.swift
//  ZegoUIKitCallWithInvitationDemo
//
//  Created by zego on 2022/10/20.
//

import UIKit
import ZegoUIKitSDK
import Toast_Swift
import ZegoUIKitPrebuiltCall
import ZegoUIKitSignalingPlugin

class ViewController: UIViewController {
    
    let appID: UInt32 = <#YourAppID#>
    let appSign: String = <#YourAppSign#>
    
    let selfUserID: String = UserDefaults.standard.object(forKey: "userID") == nil ? String(format: "%d", Int.random(in: 0...99999)) :  UserDefaults.standard.object(forKey: "userID") as! String
    
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
    let voiceCallButton: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.voiceCall.rawValue)
    let videoCallButton: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.videoCall.rawValue)
    
    var config: ZegoUIKitPrebuiltCallInvitationConfig = ZegoUIKitPrebuiltCallInvitationConfig([ZegoUIKitSignalingPlugin()], notifyWhenAppRunningInBackgroundOrQuit: true, isSandboxEnvironment: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resourceID can be used to specify the ringtone of an offline call invitation, which must be set to the same value as the Push Resource ID in ZEGOCLOUD Admin Console. This only takes effect when the notifyWhenAppRunningInBackgroundOrQuit is true.
        voiceCallButton.resourceID = "zegouikit_call"
        videoCallButton.resourceID = "zegouikit_call"
        let userName: String = selfUserID
        ZegoUIKitPrebuiltCallInvitationService.shared.initWithAppID(self.appID, appSign: self.appSign, userID: selfUserID, userName: userName, config: config)
        ZegoUIKitPrebuiltCallInvitationService.shared.delegate = self
        UserDefaults.standard.set(selfUserID, forKey: "userID")
        UserDefaults.standard.synchronize()
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
    
    @IBOutlet weak var showDeclineButton: UISwitch!
    
    @IBAction func switchAction(_ sender: Any) {
        if self.showDeclineButton.isOn {
            self.config.showDeclineButton = true
        } else {
            self.config.showDeclineButton = false
        }
    }
}

extension ViewController: ZegoUIKitPrebuiltCallInvitationServiceDelegate, UITextFieldDelegate, ZegoSendCallInvitationButtonDelegate {
    
    func onPressed(_ errorCode: Int, errorMessage: String?, errorInvitees: [ZegoUIKitPrebuiltCall.ZegoCallUser]?) {
        var toastMessage: String?
        if errorCode != 0 {
            toastMessage = String(format: "Failed to send a call invitation. code: %d,message:%@",errorCode, errorMessage ?? "")
            self.view.makeToast(toastMessage, duration: 2.0, position: .center)
        } else {
            let errorInvitees: [ZegoCallUser]? = errorInvitees
            guard let errorInvitees = errorInvitees else { return }
            var errorUsers: String = ""
            var index: Int = 0
            for user in errorInvitees {
                if index > 4 {
                    errorUsers.append(contentsOf: "...")
                    break
                }
                if index == 0 {
                    errorUsers.append(contentsOf: String(format: "%@", user.id ?? ""))
                } else {
                    errorUsers.append(contentsOf: String(format: ",%@", user.id ?? ""))
                }
                index = index + 1
            }
            toastMessage = String(format: "User doesn't exist or is offline: %@", errorUsers)
            if errorInvitees.count > 0 {
                getCurrentViewController()?.view.makeToast(toastMessage, duration: 2.0, position: .center)
            }
        }
    }

    //MARK: -ZegoUIKitPrebuiltCallInvitationServiceDelegate
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIKitPrebuiltCallConfig {
        if data.type == .voiceCall {
            if data.invitees?.count ?? 0 > 1 {
                let config = ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                return config
            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
                return config
            }
        } else {
            if data.invitees?.count ?? 0 > 1 {
                let config = ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                return config
            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                return config
            }
        }
    }
    
    func onIncomingCallDeclineButtonPressed() {
        
    }
    func onIncomingCallAcceptButtonPressed() {
        
    }
    func onOutgoingCallCancelButtonPressed() {
        
    }
    
    func onIncomingCallReceived(_ callID: String, caller: ZegoCallUser, callType: ZegoCallType, callees: [ZegoCallUser]?) {
        
    }
    func onIncomingCallCanceled(_ callID: String, caller: ZegoCallUser) {
        
    }
    func onOutgoingCallAccepted(_ callID: String, callee: ZegoCallUser) {
        
    }
    func onOutgoingCallRejectedCauseBusy(_ callID: String, callee: ZegoCallUser) {
        
    }
    func onOutgoingCallDeclined(_ callID: String, callee: ZegoCallUser) {
        
    }
    func onIncomingCallTimeout(_ callID: String,  caller: ZegoCallUser){
        
    }
    func onOutgoingCallTimeout(_ callID: String, callees: [ZegoCallUser]) {
        
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
       return currentViewController(vc)
    }
    
    func currentViewController(_ vc :UIViewController?) -> UIViewController? {
       if vc == nil {
          return nil
       }
       if let presentVC = vc?.presentedViewController {
          return currentViewController(presentVC)
       }
       else if let tabVC = vc as? UITabBarController {
          if let selectVC = tabVC.selectedViewController {
              return currentViewController(selectVC)
           }
           return nil
        }
        else if let naiVC = vc as? UINavigationController {
           return currentViewController(naiVC.visibleViewController)
        }
        else {
           return vc
        }
     }
}
