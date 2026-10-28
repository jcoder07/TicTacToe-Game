import XCTest
@testable import TicTacToe_Game

@MainActor
final class BoardLogicServiceTests: XCTestCase {
  private let rules = BoardLogicService()

  func testEveryWinningLineForBothSymbols() {
    let lines = [
      [(0,0), (0,1), (0,2)], [(1,0), (1,1), (1,2)], [(2,0), (2,1), (2,2)],
      [(0,0), (1,0), (2,0)], [(0,1), (1,1), (2,1)], [(0,2), (1,2), (2,2)],
      [(0,0), (1,1), (2,2)], [(0,2), (1,1), (2,0)]
    ]
    for symbol in [CellState.x, .o] {
      for line in lines {
        var board = Board.empty
        for (row, col) in line { board[row][col] = symbol }
        let expected = Set(line.map { CellCoordinate(row: $0.0, col: $0.1) })
        XCTAssertEqual(rules.checkWin(in: board, for: symbol).map(Set.init), expected)
      }
    }
  }

  func testFullBoardWithoutWinnerIsTie() {
    let board: Board = [[.x, .o, .x], [.x, .o, .o], [.o, .x, .x]]
    XCTAssertTrue(rules.isBoardFull(board))
    XCTAssertNil(rules.checkWin(in: board, for: .x))
    XCTAssertNil(rules.checkWin(in: board, for: .o))
  }

  func testEmptyBoardHasNoWinnerAndAllowsMove() {
    XCTAssertFalse(rules.isBoardFull(.empty))
    XCTAssertNil(rules.checkWin(in: .empty, for: .x))
    XCTAssertNil(rules.checkWin(in: .empty, for: .o))
    XCTAssertNoThrow(try rules.validateMove(row: 0, col: 0, board: .empty, gameState: .playing))
  }

  func testInvalidMovesAreRejected() {
    for (row, col) in [(-1,0), (0,-1), (3,0), (0,3)] {
      XCTAssertThrowsError(try rules.validateMove(row: row, col: col, board: .empty, gameState: .playing))
    }
    var board = Board.empty
    board[1][1] = .x
    XCTAssertThrowsError(try rules.validateMove(row: 1, col: 1, board: board, gameState: .playing))
    for state in [GameState.tied, .won(.defaultPlayer)] {
      XCTAssertThrowsError(try rules.validateMove(row: 0, col: 0, board: .empty, gameState: state))
    }
  }
}
