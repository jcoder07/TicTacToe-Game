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
    
    private let humanAvatars: [ImageResource] = [.playerBoy1, .playerBoy2, .playerGirl1, .playerGirl2]
    private let botAvatar: ImageResource = .playerBot1
    
    var body: some View {
        HStack {
            playerView(profile: $playerOne, isBotToggleEnabled: false)
            Spacer()
            versusTextView
            Spacer()
            playerView(profile: $playerTwo, isBotToggleEnabled: true)
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
    
    func playerView(profile: Binding<PlayerProfile>, isBotToggleEnabled: Bool) -> some View {
        VStack(spacing: 8) {
            characterImageArrowSwitcher(profile: profile)
            characterImageView(profile: profile.wrappedValue)
            
            HStack(spacing: 5) {
                playerNameTextView(profile: profile.wrappedValue)
                if isBotToggleEnabled {
                    characterTypeArrowSwitcher(profile: profile)
                }
            }
        }
    }
    
    func characterImageArrowSwitcher(profile: Binding<PlayerProfile>) -> some View {
        Image(systemName: "arrowtriangle.up.fill")
            .font(.title2)
            .foregroundStyle(profile.wrappedValue.type.isBot ? Color.appTheme.alternateAccent : Color.appTheme.accent)
            .opacity(profile.wrappedValue.type.isBot ? 0.3 : 1)
            .button(.press) {
                withAnimation(.easeInOut) {
                    switchHumanImage(profile: profile)
                }
            }
    }
    
    func characterImageView(profile: PlayerProfile) -> some View {
        Image(profile.image)
            .resizable()
            .scaledToFit()
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(.overall)
            .overlay (
                RoundedRectangle(cornerRadius: AppCornerRadius.overall.value)
                    .stroke(profile.type.isBot ? Color.appTheme.alternateAccent : Color.appTheme.accent, lineWidth: 0.2)
            )
            .frame(width: 90, height: 90)
    }
    
    func playerNameTextView(profile: PlayerProfile) -> some View {
        Text(profile.name.description)
            .font(.headline)
            .foregroundStyle(profile.type.isBot ? Color.appTheme.alternateAccent : Color.appTheme.accent)
    }
    
    func characterTypeArrowSwitcher(profile: Binding<PlayerProfile>) -> some View {
        Image(systemName: "arrowtriangle.right.fill")
            .foregroundStyle(profile.wrappedValue.type.isBot ? Color.appTheme.alternateAccent : Color.appTheme.accent)
            .button(.press) {
                withAnimation(.easeInOut) {
                    switchPlayerType(profile: profile)
                }
            }
    }
    
}

private extension PlayerSelectionView {
    func switchHumanImage(profile: Binding<PlayerProfile>) {
        guard profile.wrappedValue.type.isHuman else { return }
        if let currentImageIndex = humanAvatars.firstIndex(of: profile.wrappedValue.image) {
            profile.wrappedValue.image = humanAvatars[(currentImageIndex + 1) % humanAvatars.count]
        } else {
            profile.wrappedValue.image = .playerBoy1
        }
    }
    
    func switchPlayerType(profile: Binding<PlayerProfile>) {
        if profile.wrappedValue.type.isHuman {
            profile.wrappedValue = .init(
                name: .ai,
                image: botAvatar,
                type: .bot
            )
        } else {
            profile.wrappedValue = .init(
                name: .playerTwo,
                image: humanAvatars.first ?? .playerBoy1,
                type: .human
            )
        }
    }
}



fileprivate struct Preview: View {
    @State private var playerOne: PlayerProfile = .defaultPlayerOne
    @State private var playerTwo: PlayerProfile = .defaultPlayerTwo
    
    var body: some View {
        PlayerSelectionView(
            playerOne: $playerOne,
            playerTwo: $playerTwo
        )
        .infinityFrame()
        .padding()
        .background(Color.appTheme.viewBackground)
    }
}

#Preview {
    Preview()
}
