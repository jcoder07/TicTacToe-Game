//
//  CellState.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import SwiftUI

enum CellState {
    case empty
    case x
    case o
    
    var symbol: String {
        switch self {
        case .empty: return ""
        case .x: return "X"
        case .o: return "O"
        }
    }
    
    var color: Color {
        switch self {
        case .empty:
            Color.clear
        case .x:
            Color.appTheme.alternateAccent
        case .o:
            Color.appTheme.accent
        }
    }
}
