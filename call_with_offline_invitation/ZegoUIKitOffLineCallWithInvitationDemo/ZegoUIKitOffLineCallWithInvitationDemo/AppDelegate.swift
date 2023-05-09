//
//  AppDelegate.swift
//  ZegoUIKitLineOffCallWithInvitationDemo
//
//  Created by zego on 2022/12/21.
//

import UIKit
import ZegoUIKitPrebuiltCall

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ZegoUIKitPrebuiltCallInvitationService.setRemoteNotificationsDeviceToken(deviceToken)
    }
}

