//
//  ToggleAudioOutputButton.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/25.
//

import UIKit
import ZegoExpressEngine

public protocol ToggleAudioOutputButtonDelegate: AnyObject {
    func onAudioOutputButtonClick(_ isSpeaker: Bool)
}

extension ToggleAudioOutputButtonDelegate {
    func onAudioOutputButtonClick(_ isSpeaker: Bool) { }
}

open class ZegoSwitchAudioOutputButton: UIButton {

    public var iconSpeaker: UIImage = ZegoUIIconSet.iconSpeakerNomal
    public var iconEarSpeaker: UIImage = ZegoUIIconSet.iconSpeakerOff
    public var iconBluetooth: UIImage = ZegoUIIconSet.iconBluetooth
    
    public var useSpeaker: Bool = false {
        didSet {
            if useSpeaker {
                self.setImage(iconSpeaker, for: .normal)
                ZegoUIKit.shared.setAudioOutputToSpeaker(enable: true)
            } else {
                self.setImage(iconEarSpeaker, for: .normal)
                ZegoUIKit.shared.setAudioOutputToSpeaker(enable: false)
            }
        }
    }
    
    public weak var delegate: ToggleAudioOutputButtonDelegate?
    
    private var help: ToggleAudioOutputButton_Help = ToggleAudioOutputButton_Help()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.help.toggleAudioOutputButton = self
        ZegoUIKit.shared.addEventHandler(self.help)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setImage(iconEarSpeaker, for: .normal)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClick(sender: UIButton) {
        self.useSpeaker = !self.useSpeaker
        self.delegate?.onAudioOutputButtonClick(self.useSpeaker)
    }
}

fileprivate class ToggleAudioOutputButton_Help: NSObject, ZegoUIKitEventHandle {
    
    weak var toggleAudioOutputButton: ZegoSwitchAudioOutputButton?
    
    override init() {
        super.init()
    }
    
    func onAudioOutputDeviceChange(_ audioRoute: ZegoUIKitAudioOutputDevice) {
        guard let toggleAudioOutputButton = toggleAudioOutputButton else { return }
        switch audioRoute {
        case .speaker:
            toggleAudioOutputButton.setImage(toggleAudioOutputButton.iconSpeaker, for: .normal)
            toggleAudioOutputButton.isEnabled = true
        case .earSpeaker:
            toggleAudioOutputButton.setImage(toggleAudioOutputButton.iconEarSpeaker, for: .normal)
            toggleAudioOutputButton.isEnabled = true
        case .headphone:
            toggleAudioOutputButton.setImage(toggleAudioOutputButton.iconEarSpeaker, for: .normal)
            toggleAudioOutputButton.isEnabled = false
        case .airPlay,.bluetooth,.externalUSB:
            self.toggleAudioOutputButton?.isEnabled = false
            self.toggleAudioOutputButton?.setImage(self.toggleAudioOutputButton?.iconBluetooth, for: .normal)
        }
    }
    
}
