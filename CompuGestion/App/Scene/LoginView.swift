//
//  LoginView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 07/12/25.
//

import SwiftUI
import SwiftData
import Observation

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            // Fondo sutil tipo macOS
            LinearGradient(
                colors: [
                    Color(NSColor.windowBackgroundColor),
                    Color(NSColor.controlBackgroundColor)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                // Tarjeta central
                VStack(spacing: 16) {
                    // Logo / título app
                    VStack(spacing: 4) {
                        Image(systemName: "wrench.and.screwdriver")
                            .font(.system(size: 40))
                            .foregroundColor(.accentColor)

                        Text("Repair Manager")
                            .font(.title2)
                            .bold()

                        Text("Inicio de sesión")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 8)

                    // Usuario
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Usuario")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField("Ej. admin", text: $authViewModel.username)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Contraseña
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Contraseña")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        SecureField("Contraseña", text: $authViewModel.password)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Error
                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Botón de login
                    PrimaryButton(
                        title: authViewModel.isLoading ? "Entrando…" : "Iniciar sesión",
                        systemImage: "arrow.right.circle.fill",
                        isDisabled: authViewModel.isLoading
                            || authViewModel.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            || authViewModel.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ) {
                        authViewModel.login(in: modelContext)
                    }
                    .keyboardShortcut(.defaultAction)

                    // Hint de credenciales por defecto (útil en desarrollo)
                    VStack(spacing: 2) {
                        Text("Tip (desarrollo): usuario admin inicial")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("Usuario: admin · Contraseña: admin")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }
                .padding(24)
                .frame(maxWidth: 360)
                .background(.thinMaterial)
                .cornerRadius(18)
                .shadow(radius: 10)

                Spacer()
            }
            .padding()
        }
    }
}
