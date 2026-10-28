//
//  ContentView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 22-04-26.
//

import SwiftUI

struct AppModeView: View {
    @StateObject private var viewModel = AppModeViewModel()
    
    var body: some View {
        Group {
            switch viewModel.appMode {
            case .gameSetup:
                GameSetupView()
            case .game:
                GameView()
            }
        }
        .animation(.easeIn, value: viewModel.appMode)
    }
}

#Preview {
    AppModeView()
}
