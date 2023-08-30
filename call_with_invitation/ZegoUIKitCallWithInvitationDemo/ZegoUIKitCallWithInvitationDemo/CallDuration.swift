//
//  CallDuration.swift
//  ZegoUIKitCallWithInvitationDemo
//
//  Created by zego on 2023/8/17.
//

import Foundation

protocol CallDurationDelegate: AnyObject {
    func onTimeUpdate(_ duration: Int, formattedString: String)
}

class CallDuration: NSObject {
    
    private var duration: Int = 0
    private var timer: Timer?
    private var callStartTimer: Int = 0
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        return formatter
    }()
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
        var formattedString = ""
        if duration < 10 {
            formattedString = "00:0\(formatter.string(from: TimeInterval(duration)) ?? "0")"
        } else if duration < 60 {
            formattedString = "00:\(formatter.string(from: TimeInterval(duration)) ?? "0")"
        } else {
            formattedString = formatter.string(from: TimeInterval(duration)) ?? "0"
        }
        delegate?.onTimeUpdate(duration, formattedString: formattedString)
    }
    
    private func getCurrentTimestampInSeconds() -> Int {
        let currentTime = Date().timeIntervalSince1970
        return Int(currentTime)
    }
}
