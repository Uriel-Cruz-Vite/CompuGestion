//
//  InventoryListViewModel.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation
import Observation
import SwiftData

@Observable
class InventoryListViewModel {

    /// Texto para buscar en nombre, categoría o SKU
    var searchText: String = ""

    // MARK: - Mapeo y filtrado

    func filteredItems(from items: [InventoryItem]) -> [InventoryListItem] {

        let filtered = items.filter { item in
            guard !searchText.isEmpty else { return true }

            let text = searchText.lowercased()

            let matchesName = item.name.lowercased().contains(text)
            let matchesSKU = item.sku.lowercased().contains(text)
            let matchesCategory = item.category?.lowercased().contains(text) ?? false

            return matchesName || matchesSKU || matchesCategory
        }

        return filtered.map { item in
            InventoryListItem(
                id: item.persistentModelID,
                sku: item.sku,
                name: item.name,
                category: item.category,
                quantityText: "\(item.quantity)",
                unitCostText: formatCurrency(item.unitCost),
                isLowStock: item.quantity <= item.minimumStock
            )
        }
    }

    // MARK: - SwiftData Actions

    func delete(_ item: InventoryItem, in context: ModelContext) {
        context.delete(item)
        try? context.save()
    }

    // MARK: - Helpers

    private func formatCurrency(_ value: Double) -> String {
        let number = NSNumber(value: value)
        return NumberFormatter.currencyMXN.string(from: number) ?? "$0.00"
    }
}
