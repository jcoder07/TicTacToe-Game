//
//  PlayerInGameView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 27-10-26.
//

import SwiftUI

struct PlayerInGameView: View {
    let player: PlayerProfile
    let cellSymbol: CellState
    let orientation: Orientation
    let isCurrentPlayer: Bool
    let winsCount: Int
    @State private var animateArrows = false
    
    var body: some View {
        VStack(spacing: 2) {
            arrowIndicatorView
            HStack(spacing: 8) {
                switch orientation {
                case .left:
                    imageView
                    detailsView
                case .right:
                    detailsView
                    imageView
                }
            }
            .padding(12)
            .background(Color.appTheme.cellBackground)
            .cornerRadius(.cell)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.overall.value)
                    .stroke(cellSymbol.color.opacity(isCurrentPlayer ? 1 : 0), lineWidth: 2)
            )
        }
        .onAppear {
            updateAnimateArrowAnimation(isCurrentPlayer: isCurrentPlayer)
        }
        .onChange(of: isCurrentPlayer) { _, newValue in updateAnimateArrowAnimation(isCurrentPlayer: newValue)
        }
    }
}

private extension PlayerInGameView {
    var imageView: some View {
        Image(player.image)
            .resizable()
            .scaledToFit()
            .padding(8)
            .background(Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.overall.value)
                    .stroke(cellSymbol.color, lineWidth: 0.2)
            )
            .frame(width: 60, height: 60)
    }
    
    var detailsView: some View {
        VStack(alignment: orientation == .left ? .leading : .trailing, spacing: 8) {
            nameView
            HStack(spacing: 12) {
                switch orientation {
                case .left:
                    currentSymbolView
                    winsCountView
                case .right:
                    winsCountView
                    currentSymbolView
                }
            }
            .font(.title2)
        }
    }
    
    var currentSymbolView: some View {
        Image(systemName: cellSymbol == .x ? "xmark" : "circle")
            .fontWeight(.bold)
            .foregroundStyle(cellSymbol.color)
    }
    
    var winsCountView: some View {
        Text("\(winsCount)")
            .foregroundStyle(Color.appTheme.success)
            .fontWeight(.semibold)
            .underline()
    }
    
    var nameView: some View {
        ZStack(alignment: orientation == .left ? .leading : .trailing) {
            Text("Player 12")
                .font(.headline)
                .opacity(0)
            Text(player.name.description)
                .font(.headline)
                .foregroundStyle(cellSymbol.color)
        }
    }

    var arrowIndicatorView: some View {
        Group {
            Image(systemName: "chevron.down")
            Image(systemName: "chevron.down")
        }
        .fontWeight(.semibold)
        .foregroundStyle(cellSymbol.color)
        .opacity(isCurrentPlayer ? 1 : 0)
        .scaleEffect(isCurrentPlayer ? 1.1 : 0.9)
        .animation(isCurrentPlayer ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default, value: animateArrows)
    }
}

extension PlayerInGameView {
    func updateAnimateArrowAnimation(isCurrentPlayer: Bool) {
        if isCurrentPlayer {
            animateArrows = true
        } else {
            animateArrows = false
        }
    }
}

extension PlayerInGameView {
    enum Orientation {
        case left
        case right
    }
}

#Preview {
    Preview()
}

fileprivate struct Preview: View {
    var body: some View {
        HStack(spacing: 0) {
            PlayerInGameView(player: .defaultPlayerOne, cellSymbol: .x, orientation: .left, isCurrentPlayer: true, winsCount: 3)
            Spacer(minLength: 5)
            PlayerInGameView(player: .defaultPlayerTwo, cellSymbol: .o, orientation: .right, isCurrentPlayer: false, winsCount: 2)
        }
        .padding()
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
    }
}
