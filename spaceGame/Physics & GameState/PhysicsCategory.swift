//
//  PhysicsCategory.swift
//  spaceGame
//
//  Created by Abhishek Biswas on 21/04/24.
//

import Foundation

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let Player : UInt32 = 0b1 // 1
    static let Bullet : UInt32 = 0b10 // 2
    static let Enemy : UInt32 = 0b100 // 4
}


enum GameState {
    case preGame
    case inGame
    case postGame
}
