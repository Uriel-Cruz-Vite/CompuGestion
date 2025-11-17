//
//  CustomerListItem.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import SwiftData

/// Modelo ligero para mostrar clientes en una lista.
/// Se apoya en el Customer de SwiftData pero sin exponer el objeto directamente.
struct CustomerListItem: Identifiable {
    /// ID interno de SwiftData para poder localizar el Customer real
    let id: PersistentIdentifier

    /// Nombre del cliente
    let name: String

    /// Teléfono formateado (si existe)
    let phone: String?

    /// Correo (si existe)
    let email: String?

    /// Texto resumen, por ejemplo: "3 órdenes · última hace 2 días"
    let summary: String?
}
