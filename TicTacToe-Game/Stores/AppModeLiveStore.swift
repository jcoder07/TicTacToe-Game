//
//  AppModeLiveStore.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 22-04-26.
//

import Foundation
import Combine

final class AppModeLiveStore: ObservableObject {
    @Published private(set) var appMode: AppMode = .gameSetup
    
    func goGameMode() {
        appMode = .game
    }
    
    func goSetupMode() {
        appMode = .gameSetup
    }
}
