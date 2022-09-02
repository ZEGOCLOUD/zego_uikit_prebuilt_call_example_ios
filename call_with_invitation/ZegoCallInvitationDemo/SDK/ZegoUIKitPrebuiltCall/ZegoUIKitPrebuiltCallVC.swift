//
//  1v1PrebuiltViewController.swift
//  ZegoUIKitExample
//
//  Created by zego on 2022/7/14.
//

import UIKit

public protocol ZegoUIKitPrebuiltCallVCDelegate: AnyObject {
    func getForegroundView(_ userInfo: ZegoUIkitUser?) -> UIView?
    func onHangUp(_ isHandup: Bool)
    func onOnlySelfInRoom()
}

extension ZegoUIKitPrebuiltCallVCDelegate {
    func getForegroundView(_ userInfo: ZegoUIkitUser?) -> UIView? { return nil}
    func onHangUp(_ isHandup: Bool){ }
    func onOnlySelfInRoom(){ }
}

open class ZegoUIKitPrebuiltCallVC: UIViewController {
    
    public weak var delegate: ZegoUIKitPrebuiltCallVCDelegate?
    
    private var config: ZegoUIkitPrebuiltCallConfig = ZegoUIkitPrebuiltCallConfig()
    private var userID: String?
    private var userName: String?
    private var roomID: String?
    private var isHidenMenuBar: Bool = false
    private var timer: ZegoTimer? = ZegoTimer(1000)
    private var timerCount: Int = 5
    
    lazy var avContainer: ZegoAudioVideoContainer = {
        let container: ZegoAudioVideoContainer = ZegoAudioVideoContainer()
        container.delegate = self
        return container
    }()
    
    lazy var menuBar: ZegoCallMenuBar = {
        let menuBar = ZegoCallMenuBar()
        menuBar.showQuitDialogVC = self
        menuBar.config = self.config
        return menuBar
    }()
    
    public init(_ appID: UInt32, appSign: String, userID: String, userName: String, callID: String, config: ZegoUIkitPrebuiltCallConfig?) {
        super.init(nibName: nil, bundle: nil)
        ZegoUIKit.shared.initWithAppID(appID: appID, appSign: appSign)
        ZegoUIKit.shared.localUserInfo = ZegoUIkitUser.init(userID, userName)
        ZegoUIKit.shared.addEventHandler(self)
        self.userID = userID
        self.userName = userName
        self.roomID = callID
        if let config = config {
            self.config = config
        }
    }
    
    public init(_ data: ZegoCallInvitationData, config: ZegoUIkitPrebuiltCallConfig?) {
        super.init(nibName: nil, bundle: nil)
        ZegoUIKit.shared.addEventHandler(self)
        self.userID = ZegoUIKit.shared.localUserInfo?.userID
        self.userName = ZegoUIKit.shared.localUserInfo?.userName
        self.roomID = data.callID
        if let config = config {
            self.config = config
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.joinRoom()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.avContainer.view)
        self.view.addSubview(self.menuBar)
        self.setupLayout()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer = nil
    }

    public func addButtonToMenuBar(_ button: UIButton) {
        self.menuBar.addButtonToMenuBar(button)
    }
    
    func setupLayout() {
        self.avContainer.view?.zgu_constraint(equalTo: self.view, left: 0, right: 0, top: 0, bottom: 0)
        self.avContainer.setLayout(self.config.layout.mode, config: self.config.layout.config)
        self.avContainer.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        self.menuBar.backgroundColor = UIColor.clear
        self.menuBar.delegate = self
        self.menuBar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - adaptLandscapeHeight(61), width: UIScreen.main.bounds.size.width, height: adaptLandscapeHeight(61))
        
        ZegoUIKit.shared.setAudioOutputToSpeaker(enable: self.config.useSpeakerWhenjoining)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.view.addGestureRecognizer(tap)
        
        if self.config.hideMenuBarAutomatically {
            //5秒自动隐藏
            guard let timer = timer else {
                return
            }
            timer.setEventHandler {
                if self.timerCount == 0 {
                    self.hiddenMenuBar(true)
                } else {
                    self.timerCount = self.timerCount - 1
                }
            }
            timer.start()
        }
    }
    
    @objc func tapClick() {
        if self.config.hideMenuBardByClick {
            self.hiddenMenuBar(!self.isHidenMenuBar)
            guard let timer = timer else {
                return
            }
            timer.start()
            self.timerCount = 5
        } else {
            if self.timerCount <= 0 {
                self.hiddenMenuBar(false)
                guard let timer = timer else {
                    return
                }
                timer.start()
                self.timerCount = 5
            }
        }
    }
    
    private func hiddenMenuBar(_ isHidden: Bool) {
        self.isHidenMenuBar = isHidden
        UIView.animate(withDuration: 0.5) {
            let y: CGFloat = isHidden ? UIScreen.main.bounds.size.height:UIScreen.main.bounds.size.height - adaptLandscapeHeight(61)
            self.menuBar.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.size.width, height: adaptLandscapeHeight(61))
        }
    }
    
    @objc func buttonClick() {
        
    }
    
    private func joinRoom() {
        guard let roomID = self.roomID,
              let userID = self.userID,
              let userName = self.userName
        else { return }
        ZegoUIKit.shared.joinRoom(userID, userName: userName, roomID: roomID)
        ZegoUIKit.shared.turnCameraOn(userID, isOn: self.config.turnOnCameraWhenjoining)
        ZegoUIKit.shared.turnMicrophoneOn(userID, isOn: self.config.turnOnMicrophoneWhenjoining)
    }
    
    deinit {
        ZegoUIKit.shared.leaveRoom()
        print("CallViewController deinit")
    }
}

extension ZegoUIKitPrebuiltCallVC: ZegoAVContainerComponentDelegate {
    
    public func getForegroundView(_ userInfo: ZegoUIkitUser?) -> UIView? {
        guard let userInfo = userInfo else {
            return nil
        }
        
        let foregroundView: UIView? = self.delegate?.getForegroundView(userInfo)
        if let foregroundView = foregroundView {
            return foregroundView
        } else {
            // user nomal foregroundView
            let nomalForegroundView: ZegoCallNomalForegroundView = ZegoCallNomalForegroundView.init(self.config, frame: .zero)
            nomalForegroundView.userInfo = userInfo
            return nomalForegroundView
        }
    }
    
    func textWidth(_ font: UIFont, text: String) -> CGFloat {
        let maxSize: CGSize = CGSize.init(width: 57, height: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let labelSize: CGRect = NSString(string: text).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return labelSize.width
    }
}

extension ZegoUIKitPrebuiltCallVC: CallMenuBarDelegate {
    public func onMenuBarMoreButtonClick(_ buttonList: [UIView]) {
        let newList:[UIView] = buttonList
        let vc: ZegoCallMoreView = ZegoCallMoreView()
        vc.buttonList = newList
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
    
    func onHangUp(_ isHandup: Bool) {
        if isHandup {
            self.dismiss(animated: true, completion: nil)
        }
        self.delegate?.onHangUp(isHandup)
    }
}

extension ZegoUIKitPrebuiltCallVC: ZegoUIKitEventHandle {
    public func onOnlySelfInRoom() {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.onOnlySelfInRoom()
    }
}
