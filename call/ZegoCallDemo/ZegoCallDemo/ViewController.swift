//
//  ViewController.swift
//  ZegoCallDemo
//
//  Created by zego on 2022/8/19.
//

import UIKit
import ZegoUIKitPrebuiltCall

class ViewController: UIViewController {
    
    let selfUserID: String = String(format: "%d", Int.random(in: 0...99999))
    var selfUserName: String?
    let yourAppID: UInt32 = 3630571287
    let yourAppSign: String = "12a16a0cca137778fa220bf84b8af7b82ae75cddd85d7e9ca3de01d240ab1a05"
    
    @IBOutlet weak var userIDLabel: UILabel! {
        didSet {
            userIDLabel.text = selfUserID
        }
    }
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            selfUserName = String(format: "zego_%@", selfUserID)
            userNameLabel.text = selfUserName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func makeNewCall(_ sender: Any) {
        
        let config: ZegoUIkitPrebuiltCallConfig = ZegoUIkitPrebuiltCallConfig()
        let audioVideoConfig: ZegoAudioVideoViewConfig = ZegoAudioVideoViewConfig()
        let menuBarConfig: ZegoBottomMenuBarConfig = ZegoBottomMenuBarConfig()
        config.audioVideoViewConfig = audioVideoConfig
        config.bottomMenuBarConfig = menuBarConfig
        let layout: ZegoLayout = ZegoLayout()
        layout.mode = .pictureInPicture
        let pipConfig: ZegoLayoutPictureInPictureConfig = ZegoLayoutPictureInPictureConfig()
        pipConfig.smallViewPostion = .topRight
        layout.config = pipConfig
        config.layout = layout
        let callVC = ZegoUIKitPrebuiltCallVC.init(yourAppID, appSign: yourAppSign, userID: selfUserID, userName: self.selfUserName ?? "", callID: "100", config: config)
        callVC.modalPresentationStyle = .fullScreen
        self.present(callVC, animated: true, completion: nil)
    }


}
