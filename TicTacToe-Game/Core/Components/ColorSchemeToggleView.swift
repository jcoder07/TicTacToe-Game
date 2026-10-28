//
//  ColorSchemeToggleView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 28-10-26.
//

import SwiftUI
import Factory

struct ColorSchemeToggleView: View {
    @ObservedObject private var themeStore = Container.shared.themeStore()

    var body: some View {
        Image(systemName: themeStore.isDarkMode ? "sun.max.fill" : "moon.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundStyle(themeStore.isDarkMode ? Color.appTheme.alternateAccent : Color.appTheme.accent)
            .padding()
            .button(.press) {
                themeStore.isDarkMode.toggle()
            }
    }
}

#Preview {
    ColorSchemeToggleView()
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
}
