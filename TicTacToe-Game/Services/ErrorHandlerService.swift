//
//  ErrorHandlerService.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import Foundation

protocol ErrorHandlerProtocol {
  func handle(_ error: GameError)
  func logError(_ error: GameError)
}

final class ErrorHandlerService: ErrorHandlerProtocol {
  func handle(_ error: GameError) {
    logError(error)
    // we do something with it
    // Could add user notification, crash reporting, etc.
  }
  
  func logError(_ error: GameError) {
    #if DEBUG
    print("🎮 Game Error: \(error.errorDescription ?? "Unknown Error")")
    #endif
    
    // In production, send to analytics/crash reporting
  }
}
