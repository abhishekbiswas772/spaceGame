//
//  Utiliy.swift
//  spaceGame
//
//  Created by Abhishek Biswas on 20/04/24.
//

import Foundation


final class UtiliyClass {
    static let shared = UtiliyClass()
    
    public func randomPositionPoints() -> CGFloat {
        let randomPos = CGFloat(Double(arc4random()) / 0xFFFFFFFF)
        return randomPos
    }
    
    public func randomPositionPoints(min: CGFloat, max : CGFloat) -> CGFloat {
        return self.randomPositionPoints() * (max - min) + min
    }
}
