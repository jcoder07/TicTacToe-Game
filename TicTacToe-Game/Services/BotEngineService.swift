//
//  BotEngineService.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import Foundation

protocol BotEngineServiceProtocol {
  func bestMove(in board: Board, difficulty: Difficulty) -> CellCoordinate
}

struct BotEngineService: BotEngineServiceProtocol {
  func bestMove(in board: Board, difficulty: Difficulty) -> CellCoordinate {
    switch difficulty {
    case .easy:
      randomMove(from: board)
    case .medium:
      mediumMove(from: board)
    case .hard:
      optimalMove(for: .o, in: board) ?? mediumMove(from: board)
    }
  }
}

private extension BotEngineService {
  func randomMove(from board: Board) -> CellCoordinate {
    let emptyCells: [CellCoordinate] = board.enumerated().flatMap { rowIndex, row in
      row.enumerated().compactMap { colIndex, cell in
        cell == .empty ? CellCoordinate(row: rowIndex, col: colIndex) : nil
      }
    }
    return emptyCells.randomElement() ?? CellCoordinate(row: 0, col: 0)
  }
  
  func mediumMove(from board: Board) -> CellCoordinate {
    if let winningMove = immediateWinningMove(for: .o, in: board) {
      return winningMove
    }
    if let blockMove = immediateWinningMove(for: .x, in: board) {
      return blockMove
    }
    return randomMove(from: board)
  }
  
  func optimalMove(for player: CellState, in board: Board) -> CellCoordinate? {
    var bestScore = Int.min
    var move: CellCoordinate?
    for row in 0..<3 {
      for col in 0..<3 {
        if board[row][col] == .empty {
          var tempBoard = board
          tempBoard[row][col] = player
          let score = minimax(board: tempBoard, isMaximizing: false)
          if score > bestScore {
            bestScore = score
            move = CellCoordinate(row: row, col: col)
          }
        }
      }
    }
    return move
  }
  
  func minimax(board: Board, isMaximizing: Bool) -> Int {
    if let winner = checkWinner(in: board) {
      switch winner {
      case .o: return 1
      case .x: return -1
      case .empty: return 0
      }
    }
    var bestScore = isMaximizing ? Int.min : Int.max
    for row in 0..<3 {
      for col in 0..<3 {
        if board[row][col] == .empty {
          var tempBoard = board
          tempBoard[row][col] = isMaximizing ? .o : .x
          let score = minimax(board: tempBoard, isMaximizing: !isMaximizing)
          bestScore = isMaximizing ? max(bestScore, score) : min(bestScore, score)
        }
      }
    }
    return bestScore
  }
  
  func immediateWinningMove(for player: CellState, in board: Board) -> CellCoordinate? {
    for row in 0..<3 {
      for col in 0..<3 {
        if board[row][col] == .empty {
          var tempBoard = board
          tempBoard[row][col] = player
          if checkWinner(in: tempBoard) == player {
            return CellCoordinate(row: row, col: col)
          }
        }
      }
    }
    return nil
  }
  
  func checkWinner(in board: Board) -> CellState? {
    let lines = [
      [(0,0),(0,1),(0,2)],
      [(1,0),(1,1),(1,2)],
      [(2,0),(2,1),(2,2)],
      [(0,0),(1,0),(2,0)],
      [(0,1),(1,1),(2,1)],
      [(0,2),(1,2),(2,2)],
      [(0,0),(1,1),(2,2)],
      [(0,2),(1,1),(2,0)]
    ]
    for line in lines {
      let (a,b,c) = (line[0], line[1], line[2])
      let values = [board[a.0][a.1], board[b.0][b.1], board[c.0][c.1]]
      if values.allSatisfy({ $0 == .x }) { return .x }
      if values.allSatisfy({ $0 == .o }) { return .o }
    }
    return board.flatMap { $0 }.contains(.empty) ? nil : .empty
  }
}

