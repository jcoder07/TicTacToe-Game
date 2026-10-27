//
//  TicTacToe_GameApp.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 22-04-26.
//

import SwiftUI

@main
struct TicTacToe_GameApp: App {
    @AppStorage(UserDefaultKeys.isDarkMode) private var isDarkMode: Bool = true
    
    var body: some Scene {
        WindowGroup {
            AppModeView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
