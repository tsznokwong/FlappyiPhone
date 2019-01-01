//
//  RandomFunc.swift
//  FlappyiPhone
//
//  Created by Tsznok Wong on 26/1/2016.
//  Copyright © 2016 Tsznok Wong. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

extension Bundle {
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
}

public extension CGFloat{
    public static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return CGFloat.random() * (max - min) + min
    }
}

public extension SKNode{
    public func pop(_ duration: TimeInterval?){
        removeAction(forKey: "shrink")
        self.setScale(0)
        self.run(SKAction.scale(to: 1, duration: duration ?? 0.1), withKey: "pop")
    
    }
    public func shrink(_ duration: TimeInterval?){
        removeAction(forKey: "pop")
        let scaleTo0 = SKAction.scale(to: 0, duration: duration ?? 0.1)
        let delay = SKAction.wait(forDuration: duration ?? 0.1)
        let remove = SKAction.removeFromParent()
        let shrink = SKAction.sequence([scaleTo0,delay,remove])
        self.run(shrink, withKey: "shrink")
    }
}
