//
//  SettingsService.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation
import SwiftData

/// Servicio para acceder y actualizar la configuración de la app (`AppSettings`).
final class SettingsService {

    static let shared = SettingsService()

    private init() {}

    // MARK: - Obtener configuración actual

    /// Obtiene la configuración actual. Si no existe, crea una con valores por defecto.
    func currentSettings(in context: ModelContext) throws -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()
        if let existing = try context.fetch(descriptor).first {
            return existing
        } else {
            let settings = AppSettings()
            context.insert(settings)
            try context.save()
            return settings
        }
    }

    // MARK: - Actualizar configuración

    struct SettingsInput {
        var businessName: String
        var taxId: String
        var address: String
        var phone: String
        var email: String
        var defaultTaxRate: Double
    }

    /// Actualiza la configuración con los valores proporcionados.
    func updateSettings(
        _ input: SettingsInput,
        in context: ModelContext
    ) throws -> AppSettings {
        let settings = try currentSettings(in: context)

        settings.businessName = input.businessName
        settings.taxId = input.taxId
        settings.address = input.address
        settings.phone = input.phone
        settings.email = input.email
        settings.defaultTaxRate = input.defaultTaxRate
        settings.updatedAt = Date()

        try context.save()
        return settings
    }
}
