//
//  GameSetupViewModel.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 01-09-26.
//

import SwiftUI
import Combine
import Factory

@MainActor
final class GameSetupViewModel: ObservableObject {
    
    @Published var playerOne: PlayerProfile = .defaultPlayerOne {
        didSet { updatePlayerOne(with: playerOne) }
    }
    
    @Published var playerTwo: PlayerProfile = .defaultPlayerTwo {
        didSet { updatePlayerTwo(with: playerTwo) }
    }
    
    @Published var selectedDifficulty: Difficulty = .medium {
        didSet { updateDifficulty(with: selectedDifficulty) }
    }
    
    @Published var selectedFirstTurn: FirstTurn = .random {
        didSet { updateFirstTurn(with: selectedFirstTurn) }
    }
    
    @Injected(\.appModeStore) var appModeStore
    @Injected(\.gameSetupStore) var gameSetupStore
    
    init() {
        getSetupInfo()
    }
}

private extension GameSetupViewModel {
    
    func getSetupInfo() {
        playerOne = gameSetupStore.playerOne
        playerTwo = gameSetupStore.playerTwo
        selectedDifficulty = gameSetupStore.selectedDifficulty
        selectedFirstTurn = gameSetupStore.selectedFirstTurn
    }
    
    func updatePlayerOne(with playerOne: PlayerProfile) {
        gameSetupStore.playerOne = playerOne
    }
    
    func updatePlayerTwo(with playerTwo: PlayerProfile) {
        gameSetupStore.playerTwo = playerTwo
    }
    
    func updateDifficulty(with difficulty: Difficulty) {
        gameSetupStore.selectedDifficulty = selectedDifficulty
    }
    
    func updateFirstTurn(with firstTurn: FirstTurn) {
        gameSetupStore.selectedFirstTurn = selectedFirstTurn
    }
}
