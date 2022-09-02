//
//  UIImage+Load.swift
//  ZegoUIKitCallWithInvitation
//
//  Created by zego on 2022/9/2.
//

import Foundation
import UIKit

extension Resource where Base: UIImage {

    /// load image
    /// - Parameters:
    ///   - name: image Name
    ///   - bundleName: s.resource_bundles set name
    /// - Returns: description
    static func loadImage(name: String, bundleName: String) -> UIImage? {
            var image = loadImage1(name: name, in: bundleName)
            if image == nil {
                image = loadImage2(name: name, in: bundleName)
            }
            if image == nil {
                image = loadImage3(name: name, in: bundleName)
            }
            if image == nil {
                image = loadImage4(name: name, in: bundleName)
            }
            return image
        }


    /// load  .app/pod_name.bundle/.
    /// - Parameters:
    ///   - name: image Name
    ///   - bundleName: component name
    /// - Returns: description
    fileprivate static func loadImage1(name: String, in bundleName: String) -> UIImage? {
        let pathComponent = "/\(bundleName).bundle"
        return commonLoadImage(name: name, in: pathComponent)
    }

    /// 加载  .app/Frameworks/pod_name.framework/pod_name.bundle/.
    /// - Parameters:
    ///   - name: image Name
    ///   - bundleName: component name
    /// - Returns: description
    fileprivate static func loadImage2(name: String, in bundleName: String) -> UIImage? {
        let pathComponent = "/Frameworks/\(bundleName).framework/\(bundleName).bundle"
        return commonLoadImage(name: name, in: pathComponent)
    }

    /// load.app/Frameworks/pod_name.framework/.
    /// - Parameters:
    ///   - name: image Name
    ///   - bundleName: component name
    /// - Returns: description
    fileprivate static func loadImage3(name: String, in bundleName: String) -> UIImage? {
        let pathComponent = "/Frameworks/\(bundleName).framework"
        return commonLoadImage(name: name, in: pathComponent)
    }

    /// load .app/
    /// - Parameters:
    ///   - name: image Name
    ///   - bundleName: component name
    /// - Returns: description
    fileprivate static func loadImage4(name: String, in bundleName: String) -> UIImage? {
        return UIImage(named: name)
    }

    fileprivate static func commonLoadImage(name: String, in pathComponent: String) -> UIImage? {
        guard let resourcePath: String = Bundle.main.resourcePath else { return nil }
        let bundlePath = resourcePath + pathComponent
        let bundle = Bundle(path: bundlePath)
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

}
