//
//  PrimaryButton.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI

/// Botón primario reutilizable para acciones principales en la app.
struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(minHeight: 30)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .disabled(isDisabled)
    }
}
