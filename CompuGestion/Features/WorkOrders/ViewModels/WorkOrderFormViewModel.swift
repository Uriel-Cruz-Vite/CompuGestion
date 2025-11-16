//
//  WorkOrderFormViewModel.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//
import Foundation
import Observation
import SwiftData

/// ViewModel para crear / editar una orden de trabajo.
@Observable
class WorkOrderFormViewModel {

    // MARK: - Campos del formulario
    var customerName: String = ""
    var deviceDescription: String = ""
    var problemDescription: String = ""
    var status: WorkOrderStatus = .received
    var estimatedCostText: String = ""

    // MARK: - Estado interno
    private(set) var isEditing: Bool = false
    private(set) var existingOrder: WorkOrder?

    // MARK: - Init para crear o editar
    init(order: WorkOrder? = nil) {
        if let order {
            self.existingOrder = order
            self.isEditing = true

            self.customerName = order.customerName
            self.deviceDescription = order.deviceDescription
            self.problemDescription = order.problemDescription
            self.status = order.status
            self.estimatedCostText = String(order.estimatedCost)
        }
    }

    // MARK: - Propiedades de presentación

    var title: String {
        isEditing ? "Editar orden" : "Nueva orden"
    }

    var canSave: Bool {
        !customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !deviceDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !problemDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Double(estimatedCostText) != nil
    }

    // MARK: - Acciones

    /// Crea o actualiza la orden en SwiftData.
    func save(in context: ModelContext) throws {
        guard let cost = Double(estimatedCostText) else {
            return
        }

        if let order = existingOrder {
            // Editar
            order.customerName = customerName
            order.deviceDescription = deviceDescription
            order.problemDescription = problemDescription
            order.status = status
            order.estimatedCost = cost
            order.updatedAt = Date()
        } else {
            // Crear
            let newOrder = WorkOrder(
                customerName: customerName,
                deviceDescription: deviceDescription,
                problemDescription: problemDescription,
                status: status,
                estimatedCost: cost
            )
            context.insert(newOrder)
        }

        try context.save()
    }
}
