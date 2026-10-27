//
//  CellView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import SwiftUI

struct CellView: View {
    let state: CellState
    let isWinningCell: Bool
    
    var body: some View {
        Text(state.symbol)
            .font(.system(size: GameConstants.cellFontSize))
            .fontWeight(.bold)
            .foregroundColor(state.color)
            .infinityFrame()
            .background(Color.appTheme.cellBackground)
            .cornerRadius(.cell)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.cell.value)
                .stroke(Color.appTheme.success.opacity(isWinningCell ? 1 : 0), lineWidth: 3)
            )
            .aspectRatio(1, contentMode: .fit)
            .shadow(.light)
    }
}

#Preview {
    Preview()
}

fileprivate struct Preview: View {
    var body: some View {
        HStack(spacing: GameConstants.boardSpacing) {
            CellView(state: .x, isWinningCell: false)
            CellView(state: .empty, isWinningCell: false)
            CellView(state: .o, isWinningCell: true)
        }
        .infinityFrame()
        .padding()
        .background(Color.appTheme.viewBackground)
    }
}
