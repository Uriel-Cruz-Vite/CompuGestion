//
//  EmptyStateView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI

/// Vista genérica para mostrar cuando no hay datos disponibles.
struct EmptyStateView: View {
    var title: String
    var message: String? = nil
    var systemImage: String = "tray"
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 36))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            if let message {
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 4)
            }
        }
        .padding()
    }
}
