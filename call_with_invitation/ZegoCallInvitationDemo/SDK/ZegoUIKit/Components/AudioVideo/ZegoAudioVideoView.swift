//
//  AudioVideoView.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import UIKit
import ZegoExpressEngine

public protocol AudioVideoViewDelegate: AnyObject {
    func getForegroundView(_ userInfo: ZegoUIkitUser?) -> UIView?
}

open class ZegoAudioVideoView: UIView {

    public weak var delegate: AudioVideoViewDelegate? {
        didSet {
            if delegate != nil {
                self.getMaskView()
            }
        }
    }
    
    public var userID: String? {
        didSet {
            guard let userID = userID else {
                self.headLabel.isHidden = true
                return
            }
            if userID == ZegoUIKit.shared.localUserInfo?.userID {
                ZegoUIKit.shared.setLocalVideoView(renderView: self.videoView, videoMode: self.videoFillMode)
            } else {
                ZegoUIKit.shared.setRemoteVideoView(userID: userID, renderView: self.videoView, videoMode: self.videoFillMode)
            }
            if ZegoUIKit.shared.isCameraOn(userID) {
                self.headLabel.isHidden = true
                self.videoView.isHidden = false
            } else {
                self.headLabel.isHidden = false
                self.videoView.isHidden = true
            }
            self.setHeadUserName(userID)
            if delegate != nil {
                self.getMaskView()
            }
        }
    }
    
    public var roomID: String?
    
    public var audioViewBackgroudImage: UIImage? {
        didSet {
            backgroundImageView.image = audioViewBackgroudImage
        }
    }
    
    public var showVoiceWave: Bool = true
    
    public var videoFillMode: ZegoUIKitVideoFillMode = .aspectFit
    
    fileprivate lazy var headLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 23)
        label.textAlignment = .center
        label.textColor = UIColor.colorWithHexString("#222222")
        label.backgroundColor = UIColor.colorWithHexString("#DBDDE3")
        return label
    }()
    
    fileprivate lazy var wave: CALayer = {
        let radar = self.makeRadarAnimation(showRect: self.headLabel.frame, isRound: true)
        return radar
    }()
    
    fileprivate lazy var videoView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    fileprivate var animationLayer: CAShapeLayer?
    fileprivate var animationGroup: CAAnimationGroup?
    fileprivate let radarAnimation = "radarAnimation"
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var customMaskView: UIView?
    private var userInfo: ZegoUIkitUser? {
        get {
            for user in ZegoUIKit.shared.userList {
                if user.userID == self.userID {
                    return user
                }
            }
            return nil
        }
    }
    
    private let help: AudioVideoView_Help = AudioVideoView_Help()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.help.audioVideoView = self
        ZegoUIKit.shared.addEventHandler(self.help)
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.headLabel)
        self.addSubview(self.videoView)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.help.audioVideoView = self
        ZegoUIKit.shared.addEventHandler(self.help)
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.headLabel)
        self.addSubview(self.videoView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    func setupLayout() {
        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        
        self.headLabel.center = CGPoint.init(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        self.headLabel.bounds = CGRect.init(x: 0, y: 0, width: (55/95) * self.frame.size.width, height: (55/95) * self.frame.size.width)
        self.headLabel.layer.masksToBounds = true
        self.headLabel.layer.cornerRadius = (55 / 95) * self.frame.size.width * 0.5
        
        self.layer.insertSublayer(self.wave, below: self.headLabel.layer)

        self.animationLayer?.frame = self.headLabel.frame
        self.animationLayer?.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.headLabel.frame.width, height: self.headLabel.frame.height)).cgPath
        
        self.videoView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        
        self.customMaskView?.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    private func setHeadUserName(_ userID: String) {
        if let userName = ZegoUIKit.shared.getUser(userID)?.userName {
            if userName.count > 0 {
                let firstStr: String = String(userName[userName.startIndex])
                self.headLabel.text = firstStr
            }
        }
    }
    
    private func getMaskView() {
        self.customMaskView?.removeFromSuperview()
        self.customMaskView = self.delegate?.getForegroundView(userInfo)
        if let customMaskView = self.customMaskView {
            self.addSubview(customMaskView)
        }
    }
    
    
    fileprivate func makeRadarAnimation(showRect: CGRect, isRound: Bool) -> CALayer {
        // 1. 一个动态波
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = showRect
        // showRect 最大内切圆
        if isRound {
            shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: showRect.width, height: showRect.height)).cgPath
        } else {
            // 矩形
            shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: showRect.width, height: showRect.height), cornerRadius: 10).cgPath
        }
        shapeLayer.fillColor = UIColor.colorWithHexString("#DBDDE3").cgColor
        // 默认初始颜色透明度
        shapeLayer.opacity = 0.0
        self.animationLayer = shapeLayer

        // 2. 需要重复的动态波，即创建副本
        let replicator = CAReplicatorLayer()
        replicator.frame = shapeLayer.bounds
        replicator.instanceCount = 4
        replicator.instanceDelay = 1.0
        replicator.addSublayer(shapeLayer)

        // 3. 创建动画组
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(floatLiteral: 1.0)  // 开始透明度
        opacityAnimation.toValue = NSNumber(floatLiteral: 0)      // 结束时透明底

        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        if isRound {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0))      // 缩放起始大小
        } else {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0))      // 缩放起始大小
        }
        scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 0))      // 缩放结束大小

        let animGroup = CAAnimationGroup()
        animGroup.animations = [opacityAnimation, scaleAnimation]
        animGroup.duration = 3.0       // 动画执行时间
        animGroup.repeatCount = HUGE   // 最大重复
        animGroup.autoreverses = false
        self.animationGroup = animGroup

        return replicator
    }
}

fileprivate class AudioVideoView_Help: NSObject, ZegoUIKitEventHandle {
    
    weak var audioVideoView: ZegoAudioVideoView?
    var isWave: Bool = false
    
    func onRemoteUserLeave(_ userList: [ZegoUIkitUser]) {
        for userInfo in userList {
            if userInfo.userID == audioVideoView?.userID {
                self.clearVideoView()
            }
        }
    }
    
    func onCameraOn(_ user: ZegoUIkitUser, isOn: Bool) {
        if self.audioVideoView?.userID != nil && self.audioVideoView?.userID == user.userID {
            if !isOn {
                self.audioVideoView?.videoView.isHidden = true
                self.audioVideoView?.headLabel.isHidden = false
            } else {
                self.audioVideoView?.videoView.isHidden = false
                self.audioVideoView?.headLabel.isHidden = true
            }
        }
    }
    
    func onSoundLevelUpdate(_ userInfo: ZegoUIkitUser, level: Double) {
        if userInfo.userID == self.audioVideoView?.userID {
            guard let audioVideoView = audioVideoView
            else {
                return
            }
            if level > 5 {
                guard let userID = userInfo.userID else { return }
                if !self.isWave && audioVideoView.showVoiceWave && !ZegoUIKit.shared.isCameraOn(userID) {
                    guard let animationGroup = audioVideoView.animationGroup else { return }
                    audioVideoView.animationLayer?.add(animationGroup, forKey: audioVideoView.radarAnimation)
                    self.isWave = true
                }
            } else {
                if isWave {
                    audioVideoView.animationLayer?.removeAnimation(forKey: audioVideoView.radarAnimation)
                    isWave = false
                }
            }
        }
    }
    
    func clearVideoView() {
        self.audioVideoView?.userID = nil
        self.audioVideoView?.videoFillMode = .aspectFill
    }
}

