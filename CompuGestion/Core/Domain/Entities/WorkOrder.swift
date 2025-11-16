//
//  WorkOrder.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import SwiftData

/// Representa una orden de trabajo registrada en el taller.
@Model
class WorkOrder {
    // MARK: - ID único (necesario en @Model)
    @Attribute(.unique) var id: UUID

    // MARK: - Campos base
    var customerName: String
    var deviceDescription: String
    var problemDescription: String

    // MARK: - Estado (persistido como String)
    var statusRaw: String

    // MARK: - Fechas
    var createdAt: Date
    var updatedAt: Date?

    // MARK: - Costo estimado (MXN)
    var estimatedCost: Double

    // MARK: - Computed para trabajar con enum tipado
    var status: WorkOrderStatus {
        get { WorkOrderStatus(rawValue: statusRaw) ?? .received }
        set { statusRaw = newValue.rawValue }
    }

    // MARK: - Inicializador
    init(
        id: UUID = UUID(),
        customerName: String,
        deviceDescription: String,
        problemDescription: String,
        status: WorkOrderStatus,
        createdAt: Date = Date(),
        updatedAt: Date? = nil,
        estimatedCost: Double
    ) {
        self.id = id
        self.customerName = customerName
        self.deviceDescription = deviceDescription
        self.problemDescription = problemDescription
        self.statusRaw = status.rawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.estimatedCost = estimatedCost
    }
}
