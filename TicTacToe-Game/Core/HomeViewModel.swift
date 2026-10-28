//
//  HomeViewModel.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 28-10-26.
//

import Foundation
import Combine
import Factory

@MainActor
final class HomeViewModel: ObservableObject {
    @Injected(\.appModeStore) var appModeStore
    @Injected(\.gameSetupStore) var gameSetupStore
}

extension HomeViewModel {
    func playVsAI() {
        gameSetupStore.playerTwo.type = .bot
        appModeStore.goSetupMode()
    }

    func playVsHuman() {
        gameSetupStore.playerTwo.type = .human
        appModeStore.goSetupMode()
    }
}
