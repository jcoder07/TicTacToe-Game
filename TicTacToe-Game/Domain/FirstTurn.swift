//
//  FirstTurn.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 01-09-26.
//

import Foundation

enum FirstTurn: String, CaseIterable {
    case you
    case opponent
    case random
}

extension FirstTurn: CustomStringConvertible {
    var description: String {
        rawValue.capitalized
    }
}
