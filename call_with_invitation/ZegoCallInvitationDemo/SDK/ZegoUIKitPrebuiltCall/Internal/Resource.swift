//
//  Resource.swift
//  ZegoUIKitPrebuiltCallVC
//
//  Created by zego on 2022/9/2.
//

struct Resource<Base> {

    public var base: Base

    public init(_ base: Base) {
        self.base = base
    }

}

/// 兼容协议
protocol ResourceCompatible {

}

extension ResourceCompatible {

    var resource: Resource<Self> {
        Resource(self)
    }

    static var resource: Resource<Self>.Type {
        Resource<Self>.self
    }

}

import class Foundation.NSObject

extension NSObject: ResourceCompatible { }
