//
//  View+InfinityFrame.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 16-08-26.
//

import SwiftUI

extension View {
    func infinityFrame() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
