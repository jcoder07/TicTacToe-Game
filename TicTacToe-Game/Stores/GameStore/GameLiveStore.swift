//
//  GameLiveStore.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import Foundation
import Factory

final class GameLiveStore: GameStore {
  @Injected(\.boardLogicService) var boardLogicService
  @Injected(\.botEngineService) var botEngineService
  
  func validateMove(row: Int, col: Int, board: Board, gameState: GameState) throws {
    try boardLogicService.validateMove(row: row, col: col, board: board, gameState: gameState)
  }
  
  func checkWin(in board: Board, for cellSymbol: CellState) -> [CellCoordinate]? {
    boardLogicService.checkWin(in: board, for: cellSymbol)
  }
  
  func isBoardFull(_ board: Board) -> Bool {
    boardLogicService.isBoardFull(board)
  }
  
  func botBestMove(in board: [[CellState]], difficulty: Difficulty) -> CellCoordinate {
    botEngineService.bestMove(in: board, difficulty: difficulty)
  }
}

