//
//  Function.swift
//  FlappyiPhone
//
//  Created by Tsznok Wong on 19/2/2016.
//  Copyright © 2016 Tsznok Wong. All rights reserved.
//

import Foundation
import SpriteKit

let defaultFont = "04b_19"

struct Physics {
    static let Phone: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Band: UInt32 = 0x1 << 3
    static let Score: UInt32 = 0x1 << 4
    static let Coin: UInt32 = 0x1 << 5
}

func setSKPhysicsBody(_ node: SKSpriteNode, categoryBitMask:  UInt32?, collisionBitMask: UInt32?, contactTestBitMask: UInt32?, affectedByGravity: Bool?, dynamic: Bool?){
    
}
func setSKSpriteNodeProperty(_ node: SKSpriteNode, name: String?, width: CGFloat?, height: CGFloat?, x: CGFloat?, y: CGFloat?, zPosition: CGFloat?, setScale: CGFloat?){
    node.name = name ?? node.name
    node.size = CGSize(width: width ?? node.frame.width, height: height ?? node.frame.height)
    node.position = CGPoint(x: x ?? node.position.x, y: y ?? node.position.y)
    node.zPosition = zPosition ?? node.zPosition
    node.setScale(setScale ?? 1)
}

func setSKLabelNodeProperty(_ node: SKLabelNode,text: String?,name: String?, x: CGFloat?, y: CGFloat?, fontName: String?, fontSize: CGFloat?, fontColor: SKColor?, zPosition: CGFloat?){
    node.text = text ?? node.text
    node.name = name ?? node.name
    node.position = CGPoint(x: x ?? node.position.x, y: y ?? node.position.y)
    node.fontName = fontName ?? defaultFont
    node.fontSize = fontSize ?? node.fontSize
    node.fontColor = fontColor ?? node.fontColor
    node.zPosition = zPosition ?? node.zPosition
}








