//
//  WindowAppearanceSetter.swift
//  TicTacToe-Game
//
//  Created by Juan Fernandez on 28-10-26.
//

import SwiftUI

struct WindowAppearanceSetter: UIViewControllerRepresentable {
    let isDarkMode: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.view.window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}
