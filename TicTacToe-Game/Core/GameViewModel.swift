//
//  GameViewModel.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import SwiftUI
import Combine
import Factory

@MainActor
final class GameViewModel: ObservableObject {
  @Published var playerOne: Player
  @Published var playerTwo: Player
  let difficulty: Difficulty
  
  @Published private(set) var gameState: GameState = .playing
  @Published var board: Board = .empty
  @Published var currentPlayer: Player = .defaultPlayer
  @Published var nextStartingPlayer: Player = .defaultPlayer
  @Published var isBotMovePending = false
  @Published var isAnimationInProgress = false
  @Published var winningCells: [CellCoordinate] = []
  @Published var error: GameError?
  
  @Injected(\.appModeStore) var appModeStore
  @Injected(\.gameStore) var gameStore
  @Injected(\.errorHandlerService) var errorHandlerService
  @Injected(\.analyticsService) var analyticsService
  private let gameSetupStore: GameSetupLiveStore
  
  private var pendingTask: Task<Void, Never>?
  private var roundID = UUID()
  private let sleep: (Duration) async throws -> Void
  @Published private(set) var isResultReady = false

  init(
    setup: GameSetupLiveStore? = nil,
    sleep: @escaping (Duration) async throws -> Void = { try await Task.sleep(for: $0) }
  ) {
    self.sleep = sleep
    gameSetupStore = setup ?? Container.shared.gameSetupStore()
    playerOne = .init(profile: gameSetupStore.playerOne, symbol: .x)
    playerTwo = .init(profile: gameSetupStore.playerTwo, symbol: .o)
    difficulty = gameSetupStore.selectedDifficulty
    gameSetup()
    if currentPlayer.isBot {
      playBotMove()
    }
  }
  
  var isPlayHumanMoveDisabled: Bool {
    currentPlayer.isBot || isBotMovePending || isAnimationInProgress || gameState != .playing
  }
  
  var otherPlayer: Player {
    currentPlayer == playerOne ? playerTwo : playerOne
  }
  
  var showWinnerSheet: Bool {
    isResultReady
  }
  
  func stopPendingWork() {
    cancelPendingWork()
  }

  func goSetupMode() {
    cancelPendingWork()
    appModeStore.goSetupMode()
  }
  
  func resetGame() {
    cancelPendingWork()
    withAnimation(.spring(duration: GameConstants.cellsAnimation)) {
      resetBoard()
      resetGameState()
      error = nil
    }
    
    if currentPlayer.isBot {
      playBotMove()
    }
  }
  
  func fullReset() {
    resetGame()
    resetPlayerWins()
  }
  
  func playHumanMove(row: Int, col: Int) {
    guard !isPlayHumanMoveDisabled else { return }
    playMove(row: row, col: col)
  }
}

private extension GameViewModel {
  func gameSetup() {
    let currentPlayer = getFirstTurnPlayer()
    self.currentPlayer = currentPlayer
    self.nextStartingPlayer = currentPlayer
    
    analyticsService.trackGameStart(difficulty: difficulty, firstTurn: gameSetupStore.selectedFirstTurn)
  }
  
  func getFirstTurnPlayer() -> Player {
    switch gameSetupStore.selectedFirstTurn {
    case .you: playerOne
    case .opponent: playerTwo
    case .random: Bool.random() ? playerOne : playerTwo
    }
  }
  
  func playBotMove() {
    isBotMovePending = true
    let id = roundID
    pendingTask = Task { [weak self] in
      guard let self else { return }
      do {
        try await sleep(.seconds(GameConstants.botMoveDelay))
        guard !Task.isCancelled, roundID == id,
              gameState == .playing, currentPlayer.isBot else { return }
        isBotMovePending = false
        let bestMove = gameStore.botBestMove(in: board, difficulty: difficulty)
        playMove(row: bestMove.row, col: bestMove.col)
      } catch {
        // Cancellation ends this round's work without reporting a game error.
      }
    }
  }

  func playMove(row: Int, col: Int) {
    do {
      try gameStore.validateMove(row: row, col: col, board: board, gameState: gameState)
      withAnimation(.spring(duration: GameConstants.cellsAnimation)) {
        board[row][col] = currentPlayer.cellSymbol
      }
      analyticsService.trackMove(player: currentPlayer.isBot ? .bot : .human, position: .init(row: row, col: col))
      
      if let winningCellCordinatesPath = gameStore.checkWin(in: board, for: currentPlayer.cellSymbol) {
        handleGameEnd(winner: currentPlayer)
        presentResult(winningCells: winningCellCordinatesPath)
      } else if gameStore.isBoardFull(board) {
        handleGameEnd(winner: nil)
        presentResult(winningCells: [])
      } else {
        switchToNextPlayer()
      }
    } catch {
      handleError(error as? GameError ?? .invalidGameState)
    }
  }
  
  func presentResult(winningCells path: [CellCoordinate]) {
    isAnimationInProgress = true
    let id = roundID
    pendingTask = Task { [weak self] in
      guard let self else { return }
      do {
        for coordinate in path {
          try await sleep(.seconds(GameConstants.winningCellsAnimationDelay))
          guard !Task.isCancelled, roundID == id else { return }
          withAnimation(.spring(duration: GameConstants.cellsAnimation)) {
            self.winningCells.append(coordinate)
          }
        }
        try await sleep(.seconds(path.isEmpty ? GameConstants.gameOverDelay : GameConstants.winningCellsAnimationDelay))
        guard !Task.isCancelled, roundID == id else { return }
        isAnimationInProgress = false
        isResultReady = true
      } catch {
        // A reset or navigation owns cleanup; an old task must not clear new flags.
      }
    }
  }

  func handleGameEnd(winner: Player?) {
    if let winner {
      if winner == playerOne {
        playerOne.wins += 1
      } else {
        playerTwo.wins += 1
      }
      nextStartingPlayer = winner
      transitionGameState(to: .won(winner))
      analyticsService.trackGameEnd(result: winner.isBot ? .botWin : .humanWin)
    } else {
      nextStartingPlayer = otherPlayer
      transitionGameState(to: .tied)
      analyticsService.trackGameEnd(result: .tie)
    }
  }
  
  func handleError(_ error: GameError) {
    self.error = error
    errorHandlerService.handle(error)
    analyticsService.trackError(error)
  }
  
  func cancelPendingWork() {
    roundID = UUID()
    pendingTask?.cancel()
    pendingTask = nil
    isBotMovePending = false
    isAnimationInProgress = false
    isResultReady = false
  }

  func switchToNextPlayer() {
    currentPlayer = otherPlayer
    if currentPlayer.isBot {
      playBotMove()
    }
  }
  
  func transitionGameState(to newState: GameState) {
    guard gameState != newState else { return }
    gameState = newState
  }
  
  func resetBoard() {
    board = .empty
    winningCells = []
  }
  
  func resetGameState() {
    currentPlayer = nextStartingPlayer
    transitionGameState(to: .playing)
  }
  
  func resetPlayerWins() {
    playerOne.wins = 0
    playerTwo.wins = 0
  }
}

