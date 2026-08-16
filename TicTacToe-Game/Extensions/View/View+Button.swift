//
//  View+Button.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 16-08-26.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.smooth, value: configuration.isPressed)
    }
}

enum ButtonStyleOption {
    case press, plain
}

extension View {
    @ViewBuilder
    func button(_ option: ButtonStyleOption = .plain, action: @escaping () -> Void) -> some View {
        switch option {
        case .press:
            self.pressableButton(action: action)
        case .plain:
            self.plainButton(action: action)
        }
    }
    
    private func plainButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func pressableButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    Preview()
}

fileprivate struct Preview: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Continue")
                .primaryButton()
                .button(.press) {
                    
                }
            
            Text("Continue")
                .primaryButton()
                .button {
                    
                }
        }
        .padding()
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
    }
}
