//
//  SettingsView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    // Campos editables
    @State private var businessName: String = ""
    @State private var taxId: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var defaultTaxRateText: String = "0.16"

    private let settingsService = SettingsService.shared

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            HStack {
                Text("Configuración del negocio")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Divider()

            if isLoading {
                LoadingView(message: "Cargando configuración…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // MARK: - Contenido
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        if let errorMessage {
                            Text(errorMessage)
                                .foregroundStyle(Color.red)
                                .font(.caption)
                        }

                        GroupBox("Datos del negocio") {
                            VStack(alignment: .leading, spacing: 12) {

                                field(
                                    title: "Nombre comercial",
                                    placeholder: "Ej. Reparaciones Uriel",
                                    text: $businessName
                                )

                                field(
                                    title: "RFC / Identificador fiscal",
                                    placeholder: "Ej. ABCD123456XYZ",
                                    text: $taxId
                                )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Dirección")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    TextField("Calle, número, colonia, ciudad, CP", text: $address, axis: .vertical)
                                        .lineLimit(2...4)
                                }
                            }
                            .padding(.vertical, 4)
                        }

                        GroupBox("Contacto") {
                            VStack(alignment: .leading, spacing: 12) {

                                field(
                                    title: "Teléfono",
                                    placeholder: "Ej. 55 1234 5678",
                                    text: $phone
                                )

                                field(
                                    title: "Correo",
                                    placeholder: "contacto@taller.com",
                                    text: $email
                                )
                            }
                            .padding(.vertical, 4)
                        }

                        GroupBox("Facturación") {
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Tasa de impuestos por defecto")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)

                                    HStack {
                                        TextField("Ej. 0.16", text: $defaultTaxRateText)
                                            .textFieldStyle(.roundedBorder)
                                            .frame(maxWidth: 120)

                                        Text("(por ejemplo 0.16 = 16%)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }

                Divider()

                // MARK: - Barra inferior
                HStack {
                    Spacer()

                    Button("Reestablecer valores") {
                        loadSettings(resetToDefaults: true)
                    }

                    PrimaryButton(
                        title: "Guardar cambios",
                        systemImage: "checkmark",
                        isDisabled: !canSave
                    ) {
                        saveSettings()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Configuración")
        .onAppear {
            loadSettings(resetToDefaults: false)
        }
    }

    // MARK: - Helpers UI

    @ViewBuilder
    private func field(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            TextField(placeholder, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }

    // MARK: - Lógica

    private var canSave: Bool {
        !businessName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Double(defaultTaxRateText) != nil
    }

    private func loadSettings(resetToDefaults: Bool) {
        isLoading = true
        errorMessage = nil

        do {
            let settings: AppSettings
            if resetToDefaults {
                // Crea una nueva instancia con valores por defecto y la guarda
                settings = AppSettings()
                modelContext.insert(settings)
                try modelContext.save()
            } else {
                settings = try settingsService.currentSettings(in: modelContext)
            }

            businessName = settings.businessName
            taxId = settings.taxId
            address = settings.address
            phone = settings.phone
            email = settings.email
            defaultTaxRateText = String(settings.defaultTaxRate)

        } catch {
            errorMessage = "Error al cargar configuración: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func saveSettings() {
        errorMessage = nil

        guard let taxRate = Double(defaultTaxRateText) else {
            errorMessage = "La tasa de impuestos no es un número válido."
            return
        }

        let input = SettingsService.SettingsInput(
            businessName: businessName,
            taxId: taxId,
            address: address,
            phone: phone,
            email: email,
            defaultTaxRate: taxRate
        )

        do {
            _ = try settingsService.updateSettings(input, in: modelContext)
            Logger.success("Configuración actualizada correctamente")
        } catch {
            errorMessage = "Error al guardar configuración: \(error.localizedDescription)"
            Logger.error("Error al guardar configuración: \(error.localizedDescription)")
        }
    }
}
