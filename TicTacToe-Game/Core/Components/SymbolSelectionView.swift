//
//  SymbolSelectionView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 28-10-26.
//

import SwiftUI

struct SymbolSelectionView: View {
    let title: String
    @Binding var selected: CellState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            titleView
            optionsView
        }
    }
}

private extension SymbolSelectionView {
    var titleView: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(Color.appTheme.info)
    }

    var optionsView: some View {
        HStack(spacing: 8) {
            optionView(for: .x)
            optionView(for: .o)
        }
    }

    func optionView(for symbol: CellState) -> some View {
        Text(symbol.symbol)
            .font(.title2)
            .fontWeight(.heavy)
            .fontDesign(.rounded)
            .foregroundStyle(selected == symbol ? Color.appTheme.accentContrastText : symbol.color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(selected == symbol ? symbol.color : symbol.color.opacity(0.2))
            .cornerRadius(.button)
            .shadow(.light)
            .button(.press) {
                withAnimation(.spring) {
                    selected = symbol
                }
            }
    }
}

fileprivate struct Preview: View {
    @State private var selected: CellState = .x

    var body: some View {
        SymbolSelectionView(title: "Your Symbol", selected: $selected)
            .infinityFrame()
            .padding()
            .background(Color.appTheme.viewBackground)
    }
}

#Preview {
    Preview()
}
