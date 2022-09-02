//
//  ZegoAVContainerComponent.swift
//  ZegoUIKitExample
//
//  Created by zego on 2022/7/15.
//

import UIKit
import ZegoExpressEngine

public protocol ZegoAVContainerComponentDelegate: AnyObject {
    func getForegroundView(_ userInfo: ZegoUIkitUser?) -> UIView?
}


public class ZegoAudioVideoContainer: NSObject {
    
    public weak var delegate: ZegoAVContainerComponentDelegate? {
        didSet {
            
        }
    }
    public var view: ZegoAVContainerView!
    
    fileprivate var config: ZegoLayoutConfig?
    fileprivate var showSelfViewWithVideoOnly: Bool = false
    fileprivate var smallVideoView : ZegoAudioVideoView?
    private let help: ZegoAudioVideoContainer_Help = ZegoAudioVideoContainer_Help()
    var videoList = [ZegoAudioVideoView]()
    
    private let limitMargin: CGFloat = 12.0
    let topPadding: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    let bottomPadding: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    
    override init() {
        super.init()
        self.view = ZegoAVContainerView()
        self.videoList = [ZegoAudioVideoView]()
        self.help.container = self
        ZegoUIKit.shared.addEventHandler(self.help)
    }
    
    public func setLayout(_ mode:ZegoUIKitLayoutMode, config: ZegoLayoutConfig) {
        switch mode {
        case .pictureInPicture:
            self.pInPLayout(config)
        }
    }
    
    private func pInPLayout(_ config: ZegoLayoutConfig) {
        if config is ZegoLayoutPictureInPictureConfig {
            let pInPConfig = config as! ZegoLayoutPictureInPictureConfig
            self.config = pInPConfig
            let audioVideoView: ZegoAudioVideoView = ZegoAudioVideoView()
            if pInPConfig.useVideoViewAspectFill {
                audioVideoView.videoFillMode = .aspectFill
            } else {
                audioVideoView.videoFillMode = .aspectFit
            }
            audioVideoView.showVoiceWave = pInPConfig.showSoundWavesInAudioMode
            self.videoList.append(audioVideoView)
            self.view?.addSubview(audioVideoView)
            
            audioVideoView.backgroundColor = pInPConfig.largeViewBackgroundColor
            
            if (pInPConfig.largeViewBackgroundImage != nil) {
                audioVideoView.audioViewBackgroudImage = pInPConfig.largeViewBackgroundImage
            }
            audioVideoView.delegate = self.help
            audioVideoView.zgu_constraint(equalTo: self.view, left: 0, right: 0, top: 0, bottom: 0)
            
            let smallVideoView: ZegoAudioVideoView = ZegoAudioVideoView()
            if pInPConfig.useVideoViewAspectFill {
                smallVideoView.videoFillMode = .aspectFill
            } else {
                smallVideoView.videoFillMode = .aspectFit
            }
            smallVideoView.userID = ZegoUIKit.shared.localUserInfo?.userID
            self.showSelfViewWithVideoOnly = pInPConfig.showSelfViewWithVideoOnly
            if pInPConfig.showSelfViewWithVideoOnly {
                if ZegoUIKit.shared.isCameraOn(smallVideoView.userID ?? "") {
                    smallVideoView.isHidden = false
                } else {
                    smallVideoView.isHidden = true
                }
            }
            
            smallVideoView.showVoiceWave = pInPConfig.showSoundWavesInAudioMode
            
            self.videoList.append(smallVideoView)
            self.view?.addSubview(smallVideoView)
            
            self.smallVideoView = smallVideoView
            self.smallVideoView?.backgroundColor = pInPConfig.smallViewBackgroundColor

            if (pInPConfig.smallViewBackgroundImage != nil) {
                self.smallVideoView?.audioViewBackgroudImage = pInPConfig.smallViewBackgroundImage
            }
            self.smallVideoView?.layer.masksToBounds = true
            self.smallVideoView?.layer.cornerRadius = 9.0
            self.smallVideoView?.delegate = self.help
            
            if pInPConfig.switchLargeOrSmallViewByClick {
                let tapClick: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
                self.smallVideoView?.addGestureRecognizer(tapClick)
            }
            
            if pInPConfig.isSmallViewDraggable {
                let dragGesture = UIPanGestureRecognizer(target: self, action:#selector(dragViewDidDrag(gesture:)))
                self.smallVideoView?.addGestureRecognizer(dragGesture)
            }

            
            switch pInPConfig.smallViewPostion {
            case .topRight:
                self.smallVideoView?.zgu_constraint(equalTo: self.view, trailing: -12, top: 70)
                self.smallVideoView?.zgu_constraint(width: 95, height: 169, priority: nil)
                break
            case .topLeft:
                self.smallVideoView?.zgu_constraint(equalTo: self.view, leading: 12, top: 70)
                self.smallVideoView?.zgu_constraint(width: 95, height: 169, priority: nil)
                break
            case .bottomLeft:
                self.smallVideoView?.zgu_constraint(equalTo: self.view, leading: 12, bottom: 100)
                self.smallVideoView?.zgu_constraint(width: 95, height: 169, priority: nil)
                break
            case .bottomRight:
                self.smallVideoView?.zgu_constraint(equalTo: self.view, trailing: -12, bottom: 100)
                self.smallVideoView?.zgu_constraint(width: 95, height: 169, priority: nil)
                break
            }
        }
        
    }
    
    @objc func tapClick() {
        self.exchangeSelfVideoView()
    }
    
    @objc func dragViewDidDrag(gesture: UIPanGestureRecognizer) {
        guard let smallVideoView = smallVideoView else {
            return
        }
        // 移动状态
        let moveState = gesture.state
        switch moveState {
        case .changed:
            // 移动过程中,获取移动轨迹,重置center坐标点
            let point = gesture.translation(in: smallVideoView.superview)
            smallVideoView.center = CGPoint(x: smallVideoView.center.x + point.x, y: smallVideoView.center.y + point.y)
            break
        case .ended:
            // 移动结束后,相关逻辑处理,重置center坐标点
            let point = gesture.translation(in: smallVideoView.superview)
            let newPoint = CGPoint(x: smallVideoView.center.x + point.x, y: smallVideoView.center.y + point.y)
            
            // 自动吸边动画
            UIView.animate(withDuration: 0.1) {
                smallVideoView.center = self.resetPosition(point: newPoint)
            }
            break
        default: break
        }
        // 重置 panGesture
        gesture.setTranslation(.zero, in: smallVideoView.superview!)

    }
    
    // MARK: - 更新中心点位置
    private func resetPosition(point: CGPoint) -> CGPoint {
        var newPoint = point
        guard let smallVideoView = smallVideoView else {
            return newPoint
        }
        // 靠左吸边
        if point.x <= smallVideoView.superview!.frame.size.width / 2 {
            // x轴偏右移2个单位(预留可点击区域)
            if point.x <= smallVideoView.frame.size.width / 2 {
                newPoint.x = (smallVideoView.frame.size.width / 2) + limitMargin
            }
            // y轴偏下移10个单位(预留可点击区域)
            if point.y <= topPadding + 20 {
                newPoint.y = topPadding + 80
            }
            // y轴偏上移10个单位(预留可点击区域)
            if point.y >= smallVideoView.superview!.frame.height - (smallVideoView.frame.height / 2) - bottomPadding - 20 {
                newPoint.y = smallVideoView.superview!.frame.height - (smallVideoView.frame.height / 2) - bottomPadding - 60
            }
            return newPoint
        } else {
            // x轴偏左移2个单位(预留可点击区域)
            if point.x >= (smallVideoView.superview!.frame.width / 2) {
                newPoint.x = smallVideoView.superview!.frame.width - (smallVideoView.frame.size.width / 2) - 12
            }
            // y轴偏下移10个单位(预留可点击区域)
            if point.y < topPadding + 20 {
                newPoint.y = topPadding + 80
            }
            // y轴偏上移10个单位(预留可点击区域)
            if point.y >= smallVideoView.superview!.frame.height - (smallVideoView.frame.height / 2) - bottomPadding - 20 {
                newPoint.y = smallVideoView.superview!.frame.height - (smallVideoView.frame.height / 2) - bottomPadding - 60
            }
            return newPoint
        }
    }
    
    func exchangeSelfVideoView() {
        if let config = config,
           (config is ZegoLayoutPictureInPictureConfig)
        {
            let smallUserID: String? = self.smallVideoView?.userID
            for videoView in self.videoList {
                if let userID = videoView.userID,
                   userID != smallUserID
                {
                    videoView.userID = smallUserID
                    self.smallVideoView?.userID = userID
                    break
                }
            }
        }
    }
    
    deinit {
        print("ZegoAudioVideoContainer deinit")
    }
}

fileprivate class ZegoAudioVideoContainer_Help: NSObject, AudioVideoViewDelegate,ZegoUIKitEventHandle {
    
    weak var container: ZegoAudioVideoContainer?
    
    func getForegroundView(_ userInfo: ZegoUIkitUser?) -> UIView? {
        return self.container?.delegate?.getForegroundView(userInfo)
    }
    
    func onRoomStateChanged(_ reason: ZegoUIKitRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable : Any], roomID: String) {
        if reason == .logined {
            if self.container?.smallVideoView?.userID != ZegoUIKit.shared.localUserInfo?.userID {
                self.container?.smallVideoView?.userID = ZegoUIKit.shared.localUserInfo?.userID
            }
        }
    }
    
    func onAudioVideoAvailable(_ userList: [ZegoUIkitUser]) {
        guard let container = container else { return }
        for user in userList {
            for videoComponent in container.videoList {
                if videoComponent.userID != ZegoUIKit.shared.localUserInfo?.userID {
                    videoComponent.userID = user.userID
                }
            }
        }
    }
    
    func onAudioVideoUnavailable(_ userList: [ZegoUIkitUser]) {
        guard let container = container else { return }
        for user in userList {
            for videoComponent in container.videoList {
                if videoComponent.userID == user.userID {
                    videoComponent.userID = nil
                }
            }
        }
    }
    
    func onRemoteUserJoin(_ userList: [ZegoUIkitUser]) {
        guard let container = container else { return }
        for user in userList {
            for videoComponent in container.videoList {
                if videoComponent.userID == nil || videoComponent.userID != ZegoUIKit.shared.localUserInfo?.userID {
                    videoComponent.userID = user.userID
                }
            }
        }
    }
    
    func onRemoteUserLeave(_ userList: [ZegoUIkitUser]) {
        guard let container = container else { return }
        for user in userList {
            for videoView in container.videoList {
                if user.userID == videoView.userID {
                    videoView.userID = nil
                }
            }
        }
    }
    
    func onCameraOn(_ user: ZegoUIkitUser, isOn: Bool) {
        guard let container = container else { return }
        if container.showSelfViewWithVideoOnly && user.userID == container.smallVideoView?.userID {
            container.smallVideoView?.isHidden = !isOn
        }
    }
    
    private func getVideoView(_ userID: String) -> ZegoAudioVideoView? {
        guard let container = container else { return nil}
        for videoView in container.videoList {
            if videoView.userID == userID {
                return videoView
            }
        }
        return nil
    }
}

public class ZegoAVContainerView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit {
        print("ZegoAVContainerView deinit")
    }
    
}
