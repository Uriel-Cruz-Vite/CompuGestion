//
//  AppColors.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI

/// Paleta de colores centralizada para la aplicación.
/// Úsala en lugar de llamar directamente a .blue, .red, etc.
enum AppColors {

    // Fondo general de la app
    static let background = Color(nsColor: .windowBackgroundColor)

    // Fondo de tarjetas / paneles
    static let cardBackground = Color(nsColor: .controlBackgroundColor)

    // Texto principal
    static let primaryText = Color.primary

    // Texto secundario
    static let secondaryText = Color.secondary

    // Colores de énfasis
    static let accent = Color.accentColor
    static let accentSoft = Color.accentColor.opacity(0.15)

    // Estados de órdenes
    static let statusReceived       = Color.blue
    static let statusInDiagnosis    = Color.orange
    static let statusInRepair       = Color.purple
    static let statusWaitingParts   = Color.yellow
    static let statusReady          = Color.green
    static let statusDelivered      = Color.gray

    // Errores / alertas
    static let error = Color.red
    static let warning = Color.yellow
}
