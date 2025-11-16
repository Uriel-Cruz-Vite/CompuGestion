//
//  Customer.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import SwiftData

/// Representa un cliente del negocio (persona o empresa).
@Model
class Customer {
    @Attribute(.unique) var id: UUID

    var name: String
    var phone: String?
    var email: String?
    var address: String?

    // En el futuro podemos agregar relación con WorkOrder:
    // @Relationship(inverse: \WorkOrder.customer) var workOrders: [WorkOrder] = []

    init(
        id: UUID = UUID(),
        name: String,
        phone: String? = nil,
        email: String? = nil,
        address: String? = nil
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.address = address
    }
}
