//
//  InventoryListItem.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation
import SwiftData

/// Modelo ligero para mostrar productos de inventario en una lista.
/// Envuelve a InventoryItem sin exponer el objeto directamente.
struct InventoryListItem: Identifiable {
    /// ID interno de SwiftData para localizar el InventoryItem original
    let id: PersistentIdentifier

    let sku: String
    let name: String
    let category: String?
    let quantityText: String
    let unitCostText: String
    let isLowStock: Bool
}
