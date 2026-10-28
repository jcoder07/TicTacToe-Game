//
//  BoardLogicService.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import Foundation

final class BoardLogicService: BoardLogicServiceProtocol {
  func validateMove(row: Int, col: Int, board: Board, gameState: GameState) throws {
    guard row >= 0 && row < GameConstants.boardSize && col >= 0 && col < GameConstants.boardSize else {
      throw GameError.invalidMove(row: row, col: col)
    }
    guard gameState == .playing else {
      throw GameError.gameNotInProgress
    }
    guard board[row][col] == .empty else {
      throw GameError.invalidMove(row: row, col: col)
    }
  }
  
  func checkWin(in board: Board, for cellSymbol: CellState) -> [CellCoordinate]? {
    // Check rows
    for row in 0..<GameConstants.boardSize {
      if board[row].allSatisfy({ $0 == cellSymbol }) {
        return (0..<GameConstants.boardSize).map { CellCoordinate(row: row, col: $0) }
      }
    }
    // Check columns
    for col in 0..<GameConstants.boardSize {
      if (0..<GameConstants.boardSize).allSatisfy({ board[$0][col] == cellSymbol }) {
        return (0..<GameConstants.boardSize).map { CellCoordinate(row: $0, col: col) }
      }
    }
    // Check diagonal (top-left to bottom-right)
    if (0..<GameConstants.boardSize).allSatisfy({ board[$0][$0] == cellSymbol }) {
      return (0..<GameConstants.boardSize).map { CellCoordinate(row: $0, col: $0) }
    }
    // Check diagonal (top-right to bottom-left)
    if (0..<GameConstants.boardSize).allSatisfy({ board[$0][GameConstants.boardSize - 1 - $0] == cellSymbol }) {
      return (0..<GameConstants.boardSize).map { CellCoordinate(row: $0, col: GameConstants.boardSize - 1 - $0) }
    }
    return nil
  }
  
  func isBoardFull(_ board: Board) -> Bool {
    board.allSatisfy { row in
      row.allSatisfy { $0 != .empty }
    }
  }
}

