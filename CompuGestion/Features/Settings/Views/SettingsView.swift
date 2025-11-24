//
//  SettingsView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI
import SwiftData
import AppKit

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

    // Impresora de tickets
    @State private var ticketPrinterName: String = ""
    @State private var availablePrinters: [String] = []

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
                                    TextField("Calle, número, colonia, ciudad, CP",
                                              text: $address,
                                              axis: .vertical)
                                        .lineLimit(2...4)
                                        .textFieldStyle(.roundedBorder)
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

                                        Text("(0.16 = 16%)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }

                        GroupBox("Impresora de tickets") {
                            VStack(alignment: .leading, spacing: 12) {
                                if availablePrinters.isEmpty {
                                    Text("No se detectaron impresoras. Verifica la configuración del sistema.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                } else {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Impresora de tickets preferida")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)

                                        Picker("Impresora de tickets",
                                               selection: $ticketPrinterName) {
                                            ForEach(availablePrinters, id: \.self) { name in
                                                Text(name).tag(name)
                                            }
                                        }
                                        .labelsHidden()
                                        .frame(maxWidth: 300)
                                    }
                                }

                                Button {
                                    reloadPrinters()
                                } label: {
                                    Label("Actualizar lista de impresoras",
                                          systemImage: "arrow.clockwise")
                                }
                                .buttonStyle(.bordered)
                                .font(.caption)
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

                    Button("Restablecer valores") {
                        loadSettings(resetToDefaults: true)
                        reloadPrinters()
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
            reloadPrinters()
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
                // Eliminar todas las AppSettings antiguas y crear una nueva por defecto
                let descriptor = FetchDescriptor<AppSettings>()
                let all = try modelContext.fetch(descriptor)
                all.forEach { modelContext.delete($0) }

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
            ticketPrinterName = settings.ticketPrinterName

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
            defaultTaxRate: taxRate,
            ticketPrinterName: ticketPrinterName
        )

        do {
            _ = try settingsService.updateSettings(input, in: modelContext)
            Logger.success("Configuración actualizada correctamente")
        } catch {
            errorMessage = "Error al guardar configuración: \(error.localizedDescription)"
            Logger.error("Error al guardar configuración: \(error.localizedDescription)")
        }
    }

    private func reloadPrinters() {
        // Cargar impresoras disponibles en macOS
        let names = NSPrinter.printerNames
        availablePrinters = names

        // Si el valor guardado ya existe, lo respetamos; si no, elegimos el primero
        if !ticketPrinterName.isEmpty, names.contains(ticketPrinterName) {
            // ok
        } else {
            ticketPrinterName = names.first ?? ""
        }
    }
}
