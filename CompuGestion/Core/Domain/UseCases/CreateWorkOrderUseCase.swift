//
//  CreateWorkOrderUseCase.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation
import SwiftData

/// Caso de uso para crear una nueva orden de trabajo.
struct CreateWorkOrderUseCase {

    /// Ejecuta la creación de una orden y la persiste en SwiftData.
    ///
    /// - Parameters:
    ///   - customerName: Nombre del cliente (puede no existir como Customer aún).
    ///   - deviceDescription: Descripción del equipo (ej. “Laptop HP”, “PC Gamer”).
    ///   - problemDescription: Descripción del problema reportado.
    ///   - status: Estado inicial de la orden (por defecto `.received`).
    ///   - estimatedCost: Costo estimado de la reparación.
    ///   - context: `ModelContext` de SwiftData donde se guarda la orden.
    func execute(
        customerName: String,
        deviceDescription: String,
        problemDescription: String,
        status: WorkOrderStatus = .received,
        estimatedCost: Double,
        in context: ModelContext
    ) throws {
        let order = WorkOrder(
            customerName: customerName,
            deviceDescription: deviceDescription,
            problemDescription: problemDescription,
            status: status,
            estimatedCost: estimatedCost
        )

        context.insert(order)
        try context.save()
        
        Logger.success("Orden creada para \(customerName) – \(deviceDescription)")
    }
}
