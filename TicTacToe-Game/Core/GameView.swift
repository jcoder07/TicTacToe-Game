//
//  GameView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import SwiftUI

struct GameView: View {
  @StateObject var viewModel: GameViewModel = .init()
  
  var body: some View {
    VStack {
      playersStatsView
      Spacer()
      gameBoardView
      Spacer()
      actionButtonsView
    }
    .infinityFrame()
    .padding()
    .background(Color.appTheme.viewBackground)
    .sheet(isPresented: Binding(
      get: { viewModel.showWinnerSheet },
      set: { _ in }
    )) {
      GameResultView(gameState: viewModel.gameState, resetGame: viewModel.resetGame)
    }
  }
}

private extension GameView {
  var playersStatsView: some View {
    HStack(spacing: 0) {
      PlayerInGameView(
        player: viewModel.playerOne.profile,
        orientation: .left,
        isCurrentPlayer: viewModel.currentPlayer.cellSymbol == .x,
        winsCount: viewModel.playerOne.wins
      )
      Spacer(minLength: 5)
      PlayerInGameView(
        player: viewModel.playerTwo.profile,
        orientation: .right,
        isCurrentPlayer: viewModel.currentPlayer.cellSymbol == .o,
        winsCount: viewModel.playerTwo.wins
      )
    }
    .animation(.easeInOut(duration: GameConstants.playerSwapAnimationDuration), value: viewModel.currentPlayer.cellSymbol)
    .transition(.opacity.combined(with: .scale))
  }
  
  var gameBoardView: some View {
    GameBoardView(
      board: viewModel.board,
      winningCells: viewModel.winningCells,
      onCellTap: viewModel.playHumanMove
    )
    .disabled(viewModel.isPlayHumanMoveDisabled)
  }
  
  var actionButtonsView: some View {
    HStack(spacing: 32) {
      actionButtonView(sfsymbol: "house")
        .opacity(0)
      actionButtonView(sfsymbol: "arrow.clockwise", buttonSize: .large)
        .button(.press) {
          viewModel.resetGame()
        }
      actionButtonView(sfsymbol: "house")
        .button(.press) {
          viewModel.goSetupMode()
        }
    }
  }
  
  func actionButtonView(sfsymbol: String, buttonSize: ButtonSize = .medium) -> some View {
    Image(systemName: sfsymbol)
      .resizable()
      .scaledToFit()
      .padding(12)
      .foregroundColor(Color.appTheme.text.opacity(0.6))
      .frame(width: buttonSize.size, height: buttonSize.size)
      .background(Color.appTheme.cellBackground)
      .clipShape(Circle())
      .shadow(.regular)
  }
}

#Preview {
  GameView()
}

extension GameView {
  enum ButtonSize {
    case medium
    case large
  }
}

extension GameView.ButtonSize {
  var size: CGFloat {
    switch self {
    case .medium: 45
    case .large: 60
    }
  }
}
