//
//  HomeModeCardView.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 28-10-26.
//

import SwiftUI

struct HomeModeCardView: View {
    let icon: ImageResource
    let isCircularIcon: Bool
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: isCircularIcon ? .fill : .fit)
                .frame(width: 56, height: 56)
                .clipShape(isCircularIcon ? AnyShape(Circle()) : AnyShape(Rectangle()))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.appTheme.text)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(Color.appTheme.secondaryText)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Color.appTheme.secondaryText)
        }
        .padding(16)
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
        .shadow(.regular)
        .button(.press, action: action)
    }
}

#Preview {
    VStack(spacing: 16) {
        HomeModeCardView(
            icon: .avatarIa,
            isCircularIcon: true,
            title: "Play vs AI",
            subtitle: "Challenge the bot",
            action: {}
        )
        HomeModeCardView(
            icon: .arcadeVS,
            isCircularIcon: false,
            title: "VS",
            subtitle: "Play on this device",
            action: {}
        )
    }
    .padding()
    .infinityFrame()
    .background(Color.appTheme.viewBackground)
}
