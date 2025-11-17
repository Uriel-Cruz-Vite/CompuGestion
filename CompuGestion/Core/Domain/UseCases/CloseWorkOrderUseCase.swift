//
//  CloseWorkOrderUseCase.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation
import SwiftData

/// Caso de uso para marcar una orden como entregada (cerrar la orden).
struct CloseWorkOrderUseCase {

    /// Marca la orden como entregada y guarda cambios.
    ///
    /// - Parameters:
    ///   - order: La orden que se va a cerrar.
    ///   - context: `ModelContext` de SwiftData donde se guarda la orden.
    func execute(
        order: WorkOrder,
        in context: ModelContext
    ) throws {
        guard order.status != .delivered else {
            Logger.warning("Se intentó cerrar una orden que ya estaba entregada.")
            return
        }

        order.status = .delivered
        order.updatedAt = Date()

        try context.save()

        Logger.success("Orden marcada como entregada para \(order.customerName)")
    }
}
