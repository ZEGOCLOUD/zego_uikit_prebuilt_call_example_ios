//
//  CallDuration.swift
//  ZegoUIKitCallWithInvitationDemo
//
//  Created by zego on 2023/8/17.
//

import Foundation

protocol CallDurationDelegate: AnyObject {
    func onTimeUpdate(_ duration: Int)
}

class CallDuration: NSObject {
    
    private var duration: Int = 0
    private var timer: Timer?
    private var callStartTimer: Int = 0
    weak var delegate: CallDurationDelegate?
    
    override init() {
        super.init()
    }
    
    public func startTheTimer() {
        duration = 0
        callStartTimer = getCurrentTimestampInSeconds()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    public func stopTheTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerFired() {
        let currentTime: Int = getCurrentTimestampInSeconds()
        duration = currentTime - callStartTimer
        delegate?.onTimeUpdate(duration)
    }
    
    private func getCurrentTimestampInSeconds() -> Int {
        let currentTime = Date().timeIntervalSince1970
        return Int(currentTime)
    }
}
