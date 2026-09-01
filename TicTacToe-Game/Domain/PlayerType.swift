//
//  PlayerType.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 16-08-26.
//

import SwiftUI

enum PlayerType {
    case human
    case bot
}

extension PlayerType {
    var isHuman: Bool {
        self == .human
    }
    
    var isBot: Bool {
        self == .bot
    }
}
