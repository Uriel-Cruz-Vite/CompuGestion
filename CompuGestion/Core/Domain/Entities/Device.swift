//
//  Device.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import SwiftData

/// Representa un dispositivo que llega al taller para diagnóstico o reparación.
@Model
class Device {
    @Attribute(.unique) var id: UUID

    /// Nombre corto o identificador (ej: “Laptop HP”, “PC Gamer”)
    var nickname: String

    /// Marca (opcional)
    var brand: String?

    /// Modelo (opcional)
    var model: String?

    /// Número de serie (opcional)
    var serialNumber: String?

    /// Para relación inversa futura:
    /// @Relationship(inverse: \WorkOrder.device) var workOrders: [WorkOrder] = []

    init(
        id: UUID = UUID(),
        nickname: String,
        brand: String? = nil,
        model: String? = nil,
        serialNumber: String? = nil
    ) {
        self.id = id
        self.nickname = nickname
        self.brand = brand
        self.model = model
        self.serialNumber = serialNumber
    }
}
