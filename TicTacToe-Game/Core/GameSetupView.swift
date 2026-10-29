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
        .overlay(alignment: .top) {
            topBar
                .padding(.horizontal, 20)
                .padding(.top, 16)
        }
    }
}

private extension GameSetupView {
    var topBar: some View {
        HStack {
            backButton
            Spacer()
            ColorSchemeToggleView()
        }
    }

    var backButton: some View {
        Image(systemName: "chevron.left")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(Color.appTheme.text)
            .padding()
            .background(Color.appTheme.cellBackground)
            .clipShape(Circle())
            .shadow(.light)
            .button(.press) {
                viewModel.goBack()
            }
    }

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
                playerTwo: $viewModel.playerTwo,
                playerOneColor: viewModel.selectedPlayerOneSymbol.color,
                playerTwoColor: viewModel.playerTwoSymbol.color
            )
            SymbolSelectionView(
                title: "Your Symbol",
                selected: $viewModel.selectedPlayerOneSymbol
            )
            if viewModel.isVsAI {
                SelectionGroupView(
                    title: "Difficulty",
                    options: Difficulty.allCases,
                    selected: $viewModel.selectedDifficulty
                )
            }
            SelectionGroupView(
                title: "Who Goes First",
                options: FirstTurn.allCases,
                selected: $viewModel.selectedFirstTurn,
                label: { firstTurnLabel($0) }
            )
        }
    }

    func firstTurnLabel(_ firstTurn: FirstTurn) -> String {
        switch firstTurn {
        case .you: viewModel.isVsAI ? "You" : "Player 1"
        case .opponent: viewModel.isVsAI ? "AI" : "Player 2"
        case .random: "Random"
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
}

#Preview {
    GameSetupView()
}
