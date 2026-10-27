//
//  GameSetupView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 01-09-26.
//

import SwiftUI

struct GameSetupView: View {
    @AppStorage(UserDefaultKeys.isDarkMode) private var isDarkMode: Bool = true
    @StateObject private var viewModel = GameSetupViewModel()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 20) {
                logoView
                welcomeText
                gameSetupSectionView
                Spacer()
                startBattleButton
            }
            .infinityFrame()
            .padding()
            .background(Color.appTheme.viewBackground)
            
            colorSchemeToggle
        }
    }
}

private extension GameSetupView {
    var logoView: some View {
        Image(.logo)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.appTheme.accent)
    }
    
    var welcomeText: some View {
        VStack(spacing: 8) {
            Text("Tic Tac Toe")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.appTheme.accent)
            Text("The One")
                .foregroundStyle(Color.appTheme.secondaryText)
                .fontWeight(.medium)
        }
    }
    
    var gameSetupSectionView: some View {
        VStack(spacing: 28) {
            PlayerSelectionView(
                playerOne: $viewModel.playerOne,
                playerTwo: $viewModel.playerTwo
            )
            SelectionGroupView(
                title: "Difficulty",
                options: Difficulty.allCases,
                selected: $viewModel.selectedDifficulty
            )
            SelectionGroupView(
                title: "Who Goes First",
                options: FirstTurn.allCases,
                selected: $viewModel.selectedFirstTurn
            )
        }
    }
    
    var startBattleButton: some View {
        HStack(spacing: 5) {
            Image(systemName: "flame")
            Text("Start Battle")
        }
        .primaryButton()
        .button(.press) {
            viewModel.startGame()
        }
    }
    
    var colorSchemeToggle: some View {
        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundStyle(isDarkMode ? Color.appTheme.alternateAccent : Color.appTheme.accent)
            .padding()
            .button(.press) {
                toggleColorScheme()
            }
    }
}

private extension GameSetupView {
    func toggleColorScheme() {
        isDarkMode.toggle()
    }
}

#Preview {
    GameSetupView()
}
