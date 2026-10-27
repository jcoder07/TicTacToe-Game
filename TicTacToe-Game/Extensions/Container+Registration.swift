//
//  Container+Registration.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 22-04-26.
//

import Factory

extension Container {
    var appModeStore: Factory<AppModeLiveStore> {
        self { MainActor.assumeIsolated { AppModeLiveStore() } }.singleton
    }
        
    var gameSetupStore: Factory<GameSetupLiveStore> {
        self { MainActor.assumeIsolated { GameSetupLiveStore() } }.singleton
    }
}


