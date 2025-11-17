//
//  InventoryFormViewModel.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation
import Observation
import SwiftData

/// ViewModel para crear / editar un artículo de inventario.
@Observable
class InventoryFormViewModel {

    // MARK: - Campos del formulario
    var sku: String = ""
    var name: String = ""
    var category: String = ""
    var quantityText: String = ""
    var minimumStockText: String = ""
    var unitCostText: String = ""
    var location: String = ""
    var notes: String = ""

    // MARK: - Estado interno
    private(set) var isEditing: Bool = false
    private(set) var existingItem: InventoryItem?

    // MARK: - Init (crear/editar)
    init(item: InventoryItem? = nil) {
        if let item {
            self.existingItem = item
            self.isEditing = true

            self.sku = item.sku
            self.name = item.name
            self.category = item.category ?? ""
            self.quantityText = String(item.quantity)
            self.minimumStockText = String(item.minimumStock)
            self.unitCostText = String(item.unitCost)
            self.location = item.location ?? ""
            self.notes = item.notes ?? ""
        }
    }

    // MARK: - Presentación

    var title: String {
        isEditing ? "Editar artículo" : "Nuevo artículo"
    }

    var canSave: Bool {
        !sku.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Int(quantityText) != nil &&
        Int(minimumStockText) != nil &&
        Double(unitCostText) != nil
    }

    // MARK: - Acciones

    func save(in context: ModelContext) throws {
        guard
            let quantity = Int(quantityText),
            let minimumStock = Int(minimumStockText),
            let unitCost = Double(unitCostText)
        else {
            return
        }

        if let item = existingItem {
            // Editar
            item.sku = sku
            item.name = name
            item.category = category.isEmpty ? nil : category
            item.quantity = quantity
            item.minimumStock = minimumStock
            item.unitCost = unitCost
            item.location = location.isEmpty ? nil : location
            item.notes = notes.isEmpty ? nil : notes
            item.updatedAt = Date()
        } else {
            // Crear
            let newItem = InventoryItem(
                sku: sku,
                name: name,
                category: category.isEmpty ? nil : category,
                quantity: quantity,
                minimumStock: minimumStock,
                unitCost: unitCost,
                location: location.isEmpty ? nil : location,
                notes: notes.isEmpty ? nil : notes
            )
            context.insert(newItem)
        }

        try context.save()
    }
}
