//
//  LoandingView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI

/// Indicador de carga simple y reutilizable.
struct LoadingView: View {
    var message: String = "Cargando..."

    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(.circular)

            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
