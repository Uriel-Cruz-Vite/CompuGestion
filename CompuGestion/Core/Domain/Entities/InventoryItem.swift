//
//  InventoryItem.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import SwiftData

/// Representa una pieza de inventario, refacción o componente
/// que se puede utilizar en una orden de reparación.
@Model
class InventoryItem {
    @Attribute(.unique) var id: UUID

    /// Nombre de la pieza o componente (ej: “RAM DDR4 8GB”, “Fuente 600W”)
    var name: String

    /// Cantidad disponible en stock
    var quantity: Int

    /// Precio base de compra (MXN)
    var unitCost: Double

    /// Precio sugerido de venta (MXN)
    var unitPrice: Double

    /// Texto libre: proveedor, notas, compatibilidad, etc.
    var notes: String?

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Int,
        unitCost: Double,
        unitPrice: Double,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unitCost = unitCost
        self.unitPrice = unitPrice
        self.notes = notes
    }
}
