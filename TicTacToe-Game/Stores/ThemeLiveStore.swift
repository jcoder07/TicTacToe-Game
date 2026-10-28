//
//  ThemeLiveStore.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 28-10-26.
//

import Foundation
import Combine

@MainActor
final class ThemeLiveStore: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet { UserDefaults.standard.set(isDarkMode, forKey: UserDefaultKeys.isDarkMode) }
    }

    init() {
        isDarkMode = (UserDefaults.standard.object(forKey: UserDefaultKeys.isDarkMode) as? Bool) ?? true
    }
}
