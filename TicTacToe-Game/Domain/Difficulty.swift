//
//  Difficulty.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 01-09-26.
//

import Foundation

enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case hard
}

extension Difficulty: CustomStringConvertible {
    var description: String {
        rawValue.capitalized
    }
}
