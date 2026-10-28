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
    static let humanAvatars: [ImageResource] = [.avatarArcade, .avatarPixel, .avatarVisorV, .avatarVisorX]
    static let botAvatar: ImageResource = .avatarIa

    static var defaultPlayerOne: Self {
        .init(name: .playerOne, image: humanAvatars[0], type: .human)
    }

    static var defaultPlayerTwo: Self {
        defaultPlayerTwoBot
    }

    static var defaultPlayerTwoBot: Self {
        .init(name: .ai, image: botAvatar, type: .bot)
    }

    static var defaultPlayerTwoHuman: Self {
        .init(name: .playerTwo, image: humanAvatars[1], type: .human)
    }
}
