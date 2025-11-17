//
//  View+Modifiers.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI

extension View {
    
    /// Oculta la vista si la condición es verdadera.
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            self.hidden()
        } else {
            self
        }
    }

    /// Envoltorio para forzar un `frame(maxWidth:, maxHeight:)`
    func fillParent(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }

    /// Aplica padding estándar horizontal + vertical mínimo
    func paddedContainer() -> some View {
        self.padding(.horizontal, 16).padding(.vertical, 8)
    }

    /// Variante reducida de .buttonStyle(.borderedProminent)
    func primaryActionButton() -> some View {
        self.buttonStyle(.borderedProminent)
            .controlSize(.regular)
    }

    /// Equivalente a `.navigationTitle()` pero funcional en macOS detail views
    func title(_ text: String) -> some View {
        self.navigationTitle(text)
    }
}
