//
//  BoardLogicServiceProtocol.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import Foundation

protocol BoardLogicServiceProtocol {
  func validateMove(row: Int, col: Int, board: Board, gameState: GameState) throws
  func checkWin(in board: Board, for cellSymbol: CellState) -> [CellCoordinate]?
  func isBoardFull(_ board: Board) -> Bool
}
