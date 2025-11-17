//
//  TagPill.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI

/// Una etiqueta en forma de pastilla, usada para estados o categorías.
struct TagPill: View {
    var text: String
    var color: Color = .blue
    var foreground: Color = .white
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 4) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.caption)
            }

            Text(text)
                .font(.caption)
                .bold()
        }
        .foregroundStyle(foreground)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.85))
        .clipShape(Capsule())
    }
}
