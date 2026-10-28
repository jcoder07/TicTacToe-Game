//
//  Player.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import SwiftUI

struct Player {
  let profile: PlayerProfile
  let cellSymbol: CellState
  var wins: Int = 0
  
  var isBot: Bool { profile.type == .bot }
  var name: PlayerName { profile.name }
  var image: ImageResource { profile.image }
  
  init(profile: PlayerProfile, symbol: CellState) {
    self.profile = profile
    self.cellSymbol = symbol
  }
}

extension Player: Equatable {
  static func == (lhs: Player, rhs: Player) -> Bool {
    lhs.profile == rhs.profile && lhs.cellSymbol == rhs.cellSymbol
  }
}

extension Player {
  static var defaultPlayer: Self {
    .init(profile: .defaultPlayerOne, symbol: .x)
  }
}
