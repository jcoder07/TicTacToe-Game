import XCTest
@testable import TicTacToe_Game

/// Suspends work until the test releases it, even when cancelled. This also
/// checks that obsolete work cannot mutate a newer round after resuming.
@MainActor
private final class ManualDelay {
  var waiters: [CheckedContinuation<Void, Never>] = []

  func sleep(_ duration: Duration) async throws {
    await withCheckedContinuation { waiters.append($0) }
  }

  func resumeAll() {
    let pending = waiters
    waiters.removeAll()
    pending.forEach { $0.resume() }
  }
}

@MainActor
final class GameViewModelTests: XCTestCase {
  private func makeGame(_ delay: ManualDelay, botStarts: Bool = false) -> GameViewModel {
    let setup = GameSetupLiveStore()
    setup.playerOne = .defaultPlayerOne
    setup.playerTwo = botStarts ? .defaultPlayerTwo : .init(name: .playerTwo, image: .playerBoy2, type: .human)
    setup.selectedFirstTurn = botStarts ? .opponent : .you
    setup.selectedDifficulty = .easy
    return GameViewModel(setup: setup, sleep: delay.sleep)
  }

  private func settle() async {
    for _ in 0..<20 { await Task.yield() }
  }

  func testResetCancelsPreviousBotMoveWithoutUnlockingNewMove() async {
    let delay = ManualDelay()
    let game = makeGame(delay, botStarts: true)
    await settle()
    XCTAssertEqual(delay.waiters.count, 1)
    game.resetGame()
    // Release only the previous round before the new task starts sleeping.
    delay.resumeAll()
    await settle()
    XCTAssertEqual(game.board, .empty)
    XCTAssertTrue(game.isBotMovePending)
    delay.resumeAll()
    await settle()
    XCTAssertEqual(game.board.flatMap { $0 }.filter { $0 != .empty }.count, 1)
    XCTAssertFalse(game.isBotMovePending)
    game.stopPendingWork()
  }

  func testLeavingSetupCancelsBotMove() async {
    let delay = ManualDelay()
    let game = makeGame(delay, botStarts: true)
    await settle()
    game.goSetupMode()
    delay.resumeAll()
    await settle()
    XCTAssertEqual(game.board, .empty)
    XCTAssertFalse(game.isBotMovePending)
  }

  func testHumanCannotPlayDuringBotTurn() async {
    let delay = ManualDelay()
    let game = makeGame(delay, botStarts: true)
    game.playHumanMove(row: 0, col: 0)
    XCTAssertEqual(game.board, .empty)
    await settle()
    game.stopPendingWork()
    delay.resumeAll()
    await settle()
  }

  func testWinIsImmediateAndResetCancelsResultAnimation() async {
    let delay = ManualDelay()
    let game = makeGame(delay)
    for (row, col) in [(0,0), (1,0), (0,1), (1,1), (0,2)] {
      game.playHumanMove(row: row, col: col)
    }
    XCTAssertTrue(game.gameState.isGameOver)
    XCTAssertEqual(game.playerOne.wins, 1)
    XCTAssertFalse(game.showWinnerSheet)
    game.playHumanMove(row: 2, col: 2)
    XCTAssertEqual(game.board[2][2], .empty)
    await settle()
    game.resetGame()
    delay.resumeAll()
    await settle()
    XCTAssertEqual(game.gameState, .playing)
    XCTAssertEqual(game.board, .empty)
    XCTAssertTrue(game.winningCells.isEmpty)
    XCTAssertFalse(game.showWinnerSheet)
    XCTAssertEqual(game.playerOne.wins, 1)
  }

  func testWinningAnimationCompletesBeforePresentingResult() async {
    let delay = ManualDelay()
    let game = makeGame(delay)
    for (row, col) in [(0,0), (1,0), (0,1), (1,1), (0,2)] {
      game.playHumanMove(row: row, col: col)
    }
    await settle()
    for column in 0..<3 {
      delay.resumeAll()
      await settle()
      XCTAssertEqual(game.winningCells.count, column + 1)
      XCTAssertFalse(game.showWinnerSheet)
    }
    delay.resumeAll()
    await settle()
    XCTAssertTrue(game.showWinnerSheet)
    XCTAssertFalse(game.isAnimationInProgress)
    XCTAssertEqual(game.playerOne.wins, 1)
  }

  func testFullResetDuringPartialAnimationClearsScoreAndHighlights() async {
    let delay = ManualDelay()
    let game = makeGame(delay)
    for (row, col) in [(0,0), (1,0), (0,1), (1,1), (0,2)] {
      game.playHumanMove(row: row, col: col)
    }
    await settle()
    delay.resumeAll()
    await settle()
    XCTAssertEqual(game.winningCells.count, 1)
    game.fullReset()
    delay.resumeAll()
    await settle()
    XCTAssertTrue(game.winningCells.isEmpty)
    XCTAssertEqual(game.playerOne.wins, 0)
    XCTAssertEqual(game.gameState, .playing)
    XCTAssertFalse(game.showWinnerSheet)
  }

  func testTieIsImmediateAndResetCancelsPresentation() async {
    let delay = ManualDelay()
    let game = makeGame(delay)
    for (row, col) in [(0,0), (0,1), (0,2), (1,1), (1,0), (1,2), (2,1), (2,0), (2,2)] {
      game.playHumanMove(row: row, col: col)
    }
    XCTAssertEqual(game.gameState, .tied)
    XCTAssertFalse(game.showWinnerSheet)
    await settle()
    game.resetGame()
    delay.resumeAll()
    await settle()
    XCTAssertEqual(game.gameState, .playing)
    XCTAssertFalse(game.showWinnerSheet)
  }

  func testTiePresentsResultAfterDelay() async {
    let delay = ManualDelay()
    let game = makeGame(delay)
    for (row, col) in [(0,0), (0,1), (0,2), (1,1), (1,0), (1,2), (2,1), (2,0), (2,2)] {
      game.playHumanMove(row: row, col: col)
    }
    await settle()
    delay.resumeAll()
    await settle()
    XCTAssertTrue(game.showWinnerSheet)
    XCTAssertFalse(game.isAnimationInProgress)
  }
}
