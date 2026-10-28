//
//  TicTacToe_GameApp.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 22-04-26.
//

import SwiftUI
import Factory

@main
struct TicTacToe_GameApp: App {
    @StateObject private var themeStore = Container.shared.themeStore()

    var body: some Scene {
        WindowGroup {
            AppModeView()
                .environment(\.colorScheme, themeStore.isDarkMode ? .dark : .light)
                .preferredColorScheme(themeStore.isDarkMode ? .dark : .light)
                .background(WindowAppearanceSetter(isDarkMode: themeStore.isDarkMode))
        }
    }
}
