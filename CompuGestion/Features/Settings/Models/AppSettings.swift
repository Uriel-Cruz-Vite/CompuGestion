//
//  AppSettings.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation
import SwiftData

/// Configuración general de la aplicación / negocio.
/// Se guarda en SwiftData para que puedas editarla desde la pantalla de Ajustes.
@Model
final class AppSettings {

    // Nombre comercial del negocio
    var businessName: String

    // RFC u otro identificador fiscal
    var taxId: String

    // Dirección fiscal / comercial
    var address: String

    // Teléfono principal de contacto
    var phone: String

    // Correo de contacto
    var email: String

    // Tasa de impuestos por defecto (ej. 0.16 para 16%)
    var defaultTaxRate: Double

    // Fecha de creación / última actualización
    var updatedAt: Date

    init(
        businessName: String = "Repair Manager",
        taxId: String = "",
        address: String = "",
        phone: String = "",
        email: String = "",
        defaultTaxRate: Double = 0.16
    ) {
        self.businessName = businessName
        self.taxId = taxId
        self.address = address
        self.phone = phone
        self.email = email
        self.defaultTaxRate = defaultTaxRate
        self.updatedAt = Date()
    }
}
