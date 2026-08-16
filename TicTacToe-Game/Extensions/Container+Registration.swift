//
//  Container+Registration.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 22-04-26.
//

import Factory

extension Container {
    var appModeStore: Factory<AppModeLiveStore> {
        Factory(self) { AppModeLiveStore() }.singleton
    }
}


