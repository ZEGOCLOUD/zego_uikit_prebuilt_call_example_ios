//
//  ZegoPitctureInPictureLayoutConfig.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/29.
//

import UIKit

public class ZegoLayoutPictureInPictureConfig: ZegoLayoutConfig {
    public var isSmallViewDraggable: Bool = false
    public var showSelfViewWithVideoOnly: Bool = false
    public var smallViewBackgroundColor: UIColor = UIColor.colorWithHexString("#333437")
    public var largeViewBackgroundColor: UIColor = UIColor.colorWithHexString("#4A4B4D")
    public var smallViewBackgroundImage: UIImage?
    public var largeViewBackgroundImage: UIImage?
    public var smallViewPostion: ZegoViewPosition = .topRight
    public var useVideoViewAspectFill: Bool = false
    /// 是否用户可以点击小视图来切换大小视图
    public var switchLargeOrSmallViewByClick: Bool = true
    public var showSoundWavesInAudioMode: Bool = true
}
