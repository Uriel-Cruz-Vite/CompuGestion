//
//  InventoryItem.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import SwiftData

@Model
final class InventoryItem {

    @Attribute(.unique)
    var sku: String // Ej: "SSD-240-KINGSTON"

    var name: String // Ej: "Disco SSD 240GB Kingston"

    var category: String? // Ej: "Almacenamiento", "Memorias", "Tarjetas madre", etc.

    var quantity: Int // Stock actual

    var minimumStock: Int // Nivel mínimo para alerta

    var unitCost: Double // Precio por pieza

    var location: String? // Ej: "Cajón 3", "Estante A2"

    var notes: String?

    var createdAt: Date
    var updatedAt: Date

    init(
        sku: String,
        name: String,
        category: String? = nil,
        quantity: Int = 0,
        minimumStock: Int = 0,
        unitCost: Double = 0,
        location: String? = nil,
        notes: String? = nil
    ) {
        self.sku = sku
        self.name = name
        self.category = category
        self.quantity = quantity
        self.minimumStock = minimumStock
        self.unitCost = unitCost
        self.location = location
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
