//
//  ViewController.swift
//  ZegoCallDemo
//
//  Created by zego on 2022/8/19.
//

import UIKit
import ZegoUIKitPrebuiltCall
import ZegoUIKit

class ViewController: UIViewController {
    
    let selfUserID: String = String(format: "%d", Int.random(in: 0...99999))
    var selfUserName: String?
    let yourAppID: UInt32 = <#YourAppID#>
    let yourAppSign: String = <#YourAppSign#>
    
    @IBOutlet weak var userIDLabel: UILabel! {
        didSet {
            userIDLabel.text = String(format: "userid:%@", selfUserID)
        }
    }
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            selfUserName = String(format: "zego_%@", selfUserID)
            userNameLabel.text = String(format: "username:%@", selfUserName!)
        }
    }
    
    @IBOutlet weak var callTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func makeVoiceGroupCall(_ sender: Any) {
        let groupCallConfig: ZegoUIKitPrebuiltCallConfig = ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
        let callVC = ZegoUIKitPrebuiltCallVC.init(yourAppID, appSign: yourAppSign, userID: self.selfUserID, userName: self.selfUserName ?? "", callID: self.callTextField.text ?? "test_call_id", config: groupCallConfig)
        callVC.modalPresentationStyle = .fullScreen
        self.present(callVC, animated: true, completion: nil)
    }
    
    
    @IBAction func makeGroupCall(_ sender: Any) {
        let groupCallConfig: ZegoUIKitPrebuiltCallConfig = ZegoUIKitPrebuiltCallConfig.groupVideoCall()
        let callVC = ZegoUIKitPrebuiltCallVC.init(yourAppID, appSign: yourAppSign, userID: self.selfUserID, userName: self.selfUserName ?? "", callID: self.callTextField.text ?? "test_call_id", config: groupCallConfig)
        callVC.modalPresentationStyle = .fullScreen
        self.present(callVC, animated: true, completion: nil)
    }
    
}

