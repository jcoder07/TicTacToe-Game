//
//  GameSetupLiveStore.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 01-09-26.
//

import Foundation
import Combine

@MainActor
final class GameSetupLiveStore: ObservableObject {
    @Published var playerOne: PlayerProfile = .defaultPlayerOne
    @Published var playerTwo: PlayerProfile = .defaultPlayerTwo
    @Published var selectedDifficulty: Difficulty = .medium
    @Published var selectedFirstTurn: FirstTurn = .random
    @Published var selectedPlayerOneSymbol: CellState = .x
}

