//
//  PlayerSelectionView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 16-08-26.
//

import SwiftUI

struct PlayerSelectionView: View {
    @Binding var playerOne: PlayerProfile
    @Binding var playerTwo: PlayerProfile
    let playerOneColor: Color
    let playerTwoColor: Color

    var body: some View {
        HStack {
            playerView(profile: $playerOne, excludedImage: playerTwo.image, color: playerOneColor)
            Spacer()
            versusTextView
            Spacer()
            playerView(profile: $playerTwo, excludedImage: playerOne.image, color: playerTwoColor)
        }
        .padding(12)
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
    }
}

private extension PlayerSelectionView {
    var versusTextView: some View {
        Text("vs")
            .font(.title2)
            .fontWeight(.medium)
            .foregroundStyle(Color.appTheme.alternateAccent)
    }

    func playerView(profile: Binding<PlayerProfile>, excludedImage: ImageResource, color: Color) -> some View {
        VStack(spacing: 8) {
            characterImageArrowSwitcher(profile: profile, excludedImage: excludedImage, color: color)
            characterImageView(profile: profile.wrappedValue, color: color)
            playerNameTextView(profile: profile.wrappedValue, color: color)
        }
    }

    func characterImageArrowSwitcher(profile: Binding<PlayerProfile>, excludedImage: ImageResource, color: Color) -> some View {
        Image(systemName: "arrowtriangle.up.fill")
            .font(.title2)
            .foregroundStyle(color)
            .opacity(profile.wrappedValue.type.isBot ? 0 : 1)
            .button(.press) {
                withAnimation(.easeInOut) {
                    switchHumanImage(profile: profile, excludedImage: excludedImage)
                }
            }
    }

    func characterImageView(profile: PlayerProfile, color: Color) -> some View {
        Image(profile.image)
            .resizable()
            .scaledToFit()
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(.overall)
            .overlay (
                RoundedRectangle(cornerRadius: AppCornerRadius.overall.value)
                    .stroke(color, lineWidth: 0.2)
            )
            .frame(width: 90, height: 90)
    }

    func playerNameTextView(profile: PlayerProfile, color: Color) -> some View {
        Text(profile.name.description)
            .font(.headline)
            .foregroundStyle(color)
    }
}

private extension PlayerSelectionView {
    func switchHumanImage(profile: Binding<PlayerProfile>, excludedImage: ImageResource) {
        guard profile.wrappedValue.type.isHuman else { return }
        let availableAvatars = PlayerProfile.humanAvatars.filter { $0 != excludedImage }
        guard !availableAvatars.isEmpty else { return }
        if let currentIndex = availableAvatars.firstIndex(of: profile.wrappedValue.image) {
            profile.wrappedValue.image = availableAvatars[(currentIndex + 1) % availableAvatars.count]
        } else {
            profile.wrappedValue.image = availableAvatars[0]
        }
    }
}

fileprivate struct Preview: View {
    @State private var playerOne: PlayerProfile = .defaultPlayerOne
    @State private var playerTwo: PlayerProfile = .defaultPlayerTwoHuman

    var body: some View {
        PlayerSelectionView(
            playerOne: $playerOne,
            playerTwo: $playerTwo,
            playerOneColor: CellState.x.color,
            playerTwoColor: CellState.o.color
        )
        .infinityFrame()
        .padding()
        .background(Color.appTheme.viewBackground)
    }
}

#Preview {
    Preview()
}
