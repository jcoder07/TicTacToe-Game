//
//  GameSetupView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 01-09-26.
//

import SwiftUI

struct GameSetupView: View {
    @StateObject private var viewModel = GameSetupViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    GameSetupView()
}
