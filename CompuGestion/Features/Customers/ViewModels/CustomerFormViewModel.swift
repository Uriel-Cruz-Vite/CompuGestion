//
//  CustomerFormViewModel.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import Observation
import SwiftData

/// ViewModel para crear / editar un cliente.
@Observable
class CustomerFormViewModel {

    // MARK: - Campos del formulario
    var name: String = ""
    var phone: String = ""
    var email: String = ""
    var address: String = ""

    // MARK: - Estado interno
    private(set) var isEditing: Bool = false
    private(set) var existingCustomer: Customer?

    // MARK: - Init (crear o editar)
    init(customer: Customer? = nil) {
        if let customer {
            self.existingCustomer = customer
            self.isEditing = true

            self.name = customer.name
            self.phone = customer.phone ?? ""
            self.email = customer.email ?? ""
            self.address = customer.address ?? ""
        }
    }

    // MARK: - Presentación

    var title: String {
        isEditing ? "Editar cliente" : "Nuevo cliente"
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Acciones

    /// Crea o actualiza el cliente en SwiftData.
    func save(in context: ModelContext) throws {
        if let customer = existingCustomer {
            // Editar
            customer.name = name
            customer.phone = phone.isEmpty ? nil : phone
            customer.email = email.isEmpty ? nil : email
            customer.address = address.isEmpty ? nil : address
        } else {
            // Crear
            let newCustomer = Customer(
                name: name,
                phone: phone.isEmpty ? nil : phone,
                email: email.isEmpty ? nil : email,
                address: address.isEmpty ? nil : address
            )
            context.insert(newCustomer)
        }

        try context.save()
    }
}
