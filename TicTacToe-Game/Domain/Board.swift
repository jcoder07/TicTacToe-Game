//
//  Board.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import Foundation

typealias Board = [[CellState]]

extension Board {
    static var empty: Self {
        .init(repeating: .init(repeating: .empty, count: GameConstants.boardSize), count: GameConstants.boardSize)
    }
}
