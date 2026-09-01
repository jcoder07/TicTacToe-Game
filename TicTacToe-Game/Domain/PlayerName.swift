//
//  PlayerName.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 16-08-26.
//

import Foundation

enum PlayerName {
    case playerOne
    case playerTwo
    case ai
}

extension PlayerName: CustomStringConvertible {
    var description: String {
        switch self {
        case .playerOne: "Player 1"
        case .playerTwo: "Player 2"
        case .ai: "AI"
        }
    }
}
