//
//  CallDefines.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/28.
//

import Foundation
import UIKit
import ZegoUIKitSDK

public enum ZegoMenuBarButtonType: Int {
    case quitButton
    case toggleCameraButton
    case toggleMicrophoneButton
    case swtichCameraFacingButton
    case swtichAudioOutputButton
}

public enum ZegoViewPosition: Int {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

public class ZegoCallInvitationData: NSObject {
    public var callID: String?
    public var type: ZegoInvitationType?
    public var invitees: [ZegoUIkitUser]?
    public var inviter: ZegoUIkitUser?
}

enum ZegoUIKitCallIconSetType: String, Hashable {
    
    case call_accept_icon
    case call_accept_selected_icon
    case call_video_icon
    case call_video_selected_icon
    case icon_more
    case icon_more_light
    
    // MARK: - Image handling
    func load() -> UIImage {
        let image = UIImage.resource.loadImage(name: self.rawValue, bundleName: "ZegoUIKitPrebuiltCall") ?? UIImage()
        return image
    }
}


let UIkitScreenHeight = UIScreen.main.bounds.size.height
let UIKitScreenWidth = UIScreen.main.bounds.size.width

func adaptLandscapeWidth(_ x: CGFloat) -> CGFloat {
    return x * (UIKitScreenWidth / 375.0)
}

func adaptLandscapeHeight(_ x: CGFloat) -> CGFloat {
    return x * (UIkitScreenHeight / 818.0)
}

func currentViewController() -> (UIViewController?) {
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

func KeyWindow() -> UIWindow {
    let window: UIWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last!
    return window
}
