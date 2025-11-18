//
//  CustomersListViewModel.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import Observation
import SwiftData

/// ViewModel para la pantalla de lista de clientes.
@Observable
class CustomersListViewModel {

    /// Texto de búsqueda por nombre / teléfono / email
    var searchText: String = ""

    // MARK: - Filtrado

    func filteredCustomers(from customers: [Customer]) -> [Customer] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return customers
        }

        let text = trimmed.lowercased()

        return customers.filter { customer in
            let matchesName = customer.name.lowercased().contains(text)
            let matchesPhone = customer.phone?.lowercased().contains(text) ?? false
            let matchesEmail = customer.email?.lowercased().contains(text) ?? false
            return matchesName || matchesPhone || matchesEmail
        }
    }

    // MARK: - Acciones con SwiftData

    func delete(_ customer: Customer, in context: ModelContext) {
        context.delete(customer)
        try? context.save()
    }
}
