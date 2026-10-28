//
//  GameState.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import Foundation

enum GameState: Equatable {
    case playing
    case won(Player)
    case tied
    
    var isGameOver: Bool {
        switch self {
        case .playing: return false
        case .won, .tied: return true
        }
    }
    
    var isTied: Bool {
        self == .tied
    }
    
    var winnerPlayer: Player? {
        switch self {
        case .won(let player): return player
        case .tied, .playing: return nil
        }
    }
}
