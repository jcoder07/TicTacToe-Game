//
//  AnaliticsService.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import Foundation

protocol AnalyticsProtocol {
  func trackGameStart(difficulty: Difficulty, firstTurn: FirstTurn)
  func trackMove(player: PlayerType, position: CellCoordinate)
  func trackGameEnd(result: GameResult)
  func trackError(_ error: GameError)
}

final class AnalyticsService: AnalyticsProtocol {
  func trackGameStart(difficulty: Difficulty, firstTurn: FirstTurn) {
    #if DEBUG
    print("📊 Game Started - Difficulty: \(difficulty), First Turn: \(firstTurn)")
    #endif
  }
  
  func trackMove(player: PlayerType, position: CellCoordinate) {
    #if DEBUG
    print("📊 Move - Player: \(player), Position: (\(position.row), \(position.col))")
    #endif
  }
  
  func trackGameEnd(result: GameResult) {
    #if DEBUG
    print("📊 Game Ended - Result: \(result)")
    #endif
  }
  
  func trackError(_ error: GameError) {
    #if DEBUG
    print("📊 Error Tracked: \(error.errorDescription ?? "Unknown Error")")
    #endif
  }
}

