//
//  View.swift
//  Movix
//
//  Created by Codex on 21/06/2026.
//

import SwiftUI

enum MovixTheme {
    static let background = Color(uiColor: .systemBackground)
    static let elevatedBackground = Color(uiColor: .secondarySystemBackground)
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let accent = Color.red
}

extension View {
    @ViewBuilder
    func movixGlass(cornerRadius: CGFloat = 16.0, interactive: Bool = false) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.interactive(interactive), in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
    
    @ViewBuilder
    func movixClearGlass(cornerRadius: CGFloat = 16.0, interactive: Bool = false) -> some View {
        if #available(iOS 26.0, *) {
            self
                .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: cornerRadius))
                .glassEffect(.regular.interactive(interactive), in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(.ultraThinMaterial.opacity(0.72), in: RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
    
    @ViewBuilder
    func movixProminentGlass(cornerRadius: CGFloat = 16.0, interactive: Bool = false) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.tint(MovixTheme.accent).interactive(interactive), in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(MovixTheme.accent.opacity(0.88), in: RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
    
    func movixAppBackground() -> some View {
        self.background {
            MovixTheme.background
                .ignoresSafeArea()
        }
    }
}
