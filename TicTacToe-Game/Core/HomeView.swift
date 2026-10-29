//
//  HomeView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 28-10-26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            logoView
            titleView

            Spacer()

            modeSelectionView
            captionView
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
        .overlay(alignment: .top) {
            topBar
                .padding(.horizontal, 20)
                .padding(.top, 16)
        }
    }
}

private extension HomeView {
    var topBar: some View {
        HStack {
            Spacer()
            ColorSchemeToggleView()
        }
    }

    var logoView: some View {
        Image(.arcadeLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 250)
    }

    var titleView: some View {
        VStack(spacing: 8) {
            Text("Tic Tac Toe")
                .font(.system(size: 44, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.appTheme.text)
            Text("Your next move starts here")
                .font(.title3)
                .foregroundStyle(Color.appTheme.secondaryText)
        }
    }

    var modeSelectionView: some View {
        VStack(spacing: 16) {
            HomeModeCardView(
                icon: .avatarIa,
                isCircularIcon: true,
                title: "Play vs AI",
                subtitle: "Challenge the bot",
                action: { viewModel.playVsAI() }
            )
            HomeModeCardView(
                icon: .arcadeVS,
                isCircularIcon: false,
                title: "VS",
                subtitle: "Play on this device",
                action: { viewModel.playVsHuman() }
            )
        }
    }

    var captionView: some View {
        Text("Choose how you want to play")
            .font(.footnote)
            .foregroundStyle(Color.appTheme.secondaryText)
    }
}

#Preview {
    HomeView()
}
