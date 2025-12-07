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

    // Campos editables de configuración
    @State private var businessName: String = ""
    @State private var taxId: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var defaultTaxRateText: String = "0.16"

    // Impresora de tickets
    @State private var ticketPrinterName: String = ""
    @State private var availablePrinters: [String] = []

    // Gestión de usuarios
    @Query(sort: \AuthUser.createdAt, order: .forward)
    private var users: [AuthUser]

    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var newRole: AppUserRole = .cashier
    @State private var createUserMessage: String?

    private let settingsService = SettingsService.shared
    private let authService = AuthService.shared

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

                        // --- Datos del negocio ---
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

                        // --- Contacto ---
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

                        // --- Facturación ---
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

                        // --- Impresora de tickets ---
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

                        // --- Gestión de usuarios (solo Admin) ---
                        GroupBox("Usuarios (solo administrador)") {
                            VStack(alignment: .leading, spacing: 12) {

                                // Lista de usuarios existentes
                                // Lista de usuarios existentes
                                if users.isEmpty {
                                    Text("No hay usuarios registrados aparte del administrador inicial.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                } else {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Usuarios registrados")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)

                                        ForEach(users) { user in
                                            HStack {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(user.username)
                                                        .font(.subheadline)
                                                    Text(user.role.localizedName)
                                                        .font(.caption2)
                                                        .foregroundStyle(.secondary)
                                                }

                                                Spacer()

                                                if user.isActive {
                                                    Text("Activo")
                                                        .font(.caption2)
                                                        .foregroundStyle(.green)
                                                } else {
                                                    Text("Inactivo")
                                                        .font(.caption2)
                                                        .foregroundStyle(.secondary)
                                                }

                                                // Botón eliminar
                                                Button(role: .destructive) {
                                                    deleteUser(user)
                                                } label: {
                                                    Image(systemName: "trash")
                                                }
                                                .buttonStyle(.borderless)
                                                .help("Eliminar usuario")
                                            }
                                            .padding(6)
                                            .background(Color.gray.opacity(0.08))
                                            .cornerRadius(8)
                                        }
                                    }
                                }

                                Divider()
                                    .padding(.vertical, 4)

                                // Crear nuevo usuario
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Crear nuevo usuario")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)

                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Usuario")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                            TextField("Ej. cajero1", text: $newUsername)
                                                .textFieldStyle(.roundedBorder)
                                                .frame(width: 140)
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Contraseña")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                            SecureField("Contraseña", text: $newPassword)
                                                .textFieldStyle(.roundedBorder)
                                                .frame(width: 140)
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Rol")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                            Picker("Rol", selection: $newRole) {
                                                ForEach(AppUserRole.allCases) { role in
                                                    Text(role.localizedName)
                                                        .tag(role)
                                                }
                                            }
                                            .labelsHidden()
                                            .frame(width: 140)
                                        }

                                        Button {
                                            createUser()
                                        } label: {
                                            Label("Crear", systemImage: "plus.circle.fill")
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .disabled(!canCreateUser)
                                    }

                                    if let createUserMessage {
                                        Text(createUserMessage)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }

                        // --- Herramientas de desarrollo (Reset DB) ---
                        GroupBox("Herramientas de desarrollo") {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Reset DB")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Text("Elimina TODOS los datos de clientes, órdenes, inventario, facturas, usuarios y configuración. Úsalo solo para desarrollo.")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)

                                Button(role: .destructive) {
                                    resetDatabase()
                                } label: {
                                    Label("Eliminar todos los datos (Reset DB)",
                                          systemImage: "trash")
                                }
                                .buttonStyle(.borderedProminent)
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

    // MARK: - Lógica configuración

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
            ticketPrinterName = settings.ticketPrinterName ?? ""

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

    // MARK: - Gestión de usuarios

    private var canCreateUser: Bool {
        !newUsername.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !newPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func createUser() {
        createUserMessage = nil

        let username = newUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !username.isEmpty, !password.isEmpty else {
            createUserMessage = "Usuario y contraseña son obligatorios."
            return
        }

        do {
            _ = try authService.createUser(
                username: username,
                password: password,
                role: newRole,
                in: modelContext
            )
            newUsername = ""
            newPassword = ""
            createUserMessage = "Usuario creado correctamente."
        } catch {
            createUserMessage = error.localizedDescription
            Logger.error("Error al crear usuario: \(error.localizedDescription)")
        }
    }

    // MARK: - Reset DB (solo desarrollo)

    private func resetDatabase() {
        errorMessage = nil

        do {
            try deleteAll(of: Customer.self)
            try deleteAll(of: WorkOrder.self)
            try deleteAll(of: InventoryItem.self)
            try deleteAll(of: Invoice.self)
            try deleteAll(of: AppSettings.self)
            try deleteAll(of: AuthUser.self)

            // Crear una nueva configuración por defecto
            let settings = AppSettings()
            modelContext.insert(settings)
            try modelContext.save()

            // Recargar en UI
            loadSettings(resetToDefaults: false)

            Logger.success("Reset DB completado correctamente")

        } catch {
            errorMessage = "Error al hacer Reset DB: \(error.localizedDescription)"
            Logger.error("Error al hacer Reset DB: \(error.localizedDescription)")
        }
    }

    private func deleteAll<T: PersistentModel>(of type: T.Type) throws {
        let descriptor = FetchDescriptor<T>()
        let all = try modelContext.fetch(descriptor)
        all.forEach { modelContext.delete($0) }
    }
    
    // MARK: - Eliminar usuario individual

    private func deleteUser(_ user: AuthUser) {
        // Opcional: proteger al admin inicial
        if user.username == "admin" {
            createUserMessage = "No puedes eliminar el usuario administrador inicial."
            return
        }

        do {
            modelContext.delete(user)
            try modelContext.save()
            createUserMessage = "Usuario eliminado correctamente."
            Logger.success("Usuario \(user.username) eliminado.")
        } catch {
            createUserMessage = "Error al eliminar usuario: \(error.localizedDescription)"
            Logger.error("Error al eliminar usuario: \(error.localizedDescription)")
        }
    }
}
