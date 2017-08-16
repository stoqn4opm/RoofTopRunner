//
//  Helpers.swift
//  RoofTopRunner
//
//  Created by Stoyan Stoyanov on 5/15/17.
//  Copyright © 2017 Stoyan Stoyanov. All rights reserved.
//

import UIKit
import SpriteKit

//MARK: CoreGraphics Helpers

extension CGPoint {
    static var normalizedMiddle: CGPoint {
        return CGPoint(x: 0.5, y: 0.5)
    }
    
    static var normalizedUpperLeft: CGPoint {
        return CGPoint(x: 0, y: 1)
    }
    
    static var normalizedUpperRight: CGPoint {
        return CGPoint(x: 1, y: 1)
    }
    
    static var normalizedUpperCenter: CGPoint {
        return CGPoint(x: 0.5, y: 1)
    }
    
    static var normalizedLowerCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0)
    }
    
    static var normalizedLowerLeft: CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    static var normalizedLowerRight: CGPoint {
        return CGPoint(x: 1, y: 0)
    }
    
    static var normalizedLeft: CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }
}

extension CGSize {
    
    func scaled(at scale: CGFloat = UIScreen.main.scale) -> CGSize {
        let size = CGSize(width: width * scale, height: height * scale)
        return size
    }
    
    func deltaInRegardsTo(_ size: CGSize) -> CGSize {
        let result = CGSize(width: fabs(size.width - self.width), height: fabs(size.height - self.height))
        return result
    }
}

extension UIFont {
    static func printAllFontNames() {
        for family: String in UIFont.familyNames {
            print("family - \(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("\t- \(names)")
            }
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(withComment comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

extension SKNode {
    var rootChildNode: SKNode? {
        if let child = self.children.first?.children.first { return child }
        else { return nil }
    }
}

