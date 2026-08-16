//
//  View+CornerRadius.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 16-08-26.
//

import SwiftUI

struct AppCornerRadius {
    let value: CGFloat
}

extension View {
    func cornerRadius(_ appCornerRadius: AppCornerRadius) -> some View {
        self
            .cornerRadius(appCornerRadius.value)
    }
}

extension AppCornerRadius {
    static var overall: Self = .init(value: 8)
    static var cell: Self = .init(value: 8)
    static var button: Self = .init(value: 8)
    static var textfield: Self = .init(value: 8)
}

#Preview {
    Preview()
}

fileprivate struct Preview: View {
    var body: some View {
        Text("Calculate")
            .foregroundStyle(Color.appTheme.accentContrastText)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.appTheme.accent)
            .cornerRadius(.button)
            .button(.press) {

            }
            .padding()
            .infinityFrame()
            .background(Color.appTheme.viewBackground)
    }
}
