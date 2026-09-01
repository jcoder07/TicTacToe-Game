//
//  PlayerProfile.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 16-08-26.
//

import SwiftUI

struct PlayerProfile: Equatable {
    var name: PlayerName
    var image: ImageResource
    var type: PlayerType
}

extension PlayerProfile {
    static var defaultPlayerOne: Self {
        .init(name: .playerOne, image: .playerBoy1, type: .human)
    }
    
    static var defaultPlayerTwo: Self {
        .init(name: .ai, image: .playerBot1, type: .bot)
    }
}
