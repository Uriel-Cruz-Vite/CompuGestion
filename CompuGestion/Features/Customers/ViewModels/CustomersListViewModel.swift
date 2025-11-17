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
/// No hace fetch directo: recibe los `Customer` (via @Query) y aplica
/// búsqueda + mapeo a `CustomerListItem`.
@Observable
class CustomersListViewModel {

    // Texto de búsqueda por nombre / teléfono / email
    var searchText: String = ""

    // MARK: - Filtrado y mapeo

    func filteredItems(from customers: [Customer]) -> [CustomerListItem] {
        let filtered = customers.filter { customer in
            guard !searchText.isEmpty else { return true }

            let text = searchText.lowercased()

            let matchesName = customer.name.lowercased().contains(text)
            let matchesPhone = customer.phone?.lowercased().contains(text) ?? false
            let matchesEmail = customer.email?.lowercased().contains(text) ?? false

            return matchesName || matchesPhone || matchesEmail
        }

        return filtered.map { customer in
            CustomerListItem(
                id: customer.persistentModelID,
                name: customer.name,
                phone: customer.phone,
                email: customer.email,
                summary: nil // más tarde podemos mostrar "X órdenes" aquí
            )
        }
    }

    // MARK: - Acciones con SwiftData

    func delete(_ customer: Customer, in context: ModelContext) {
        context.delete(customer)
        try? context.save()
    }
}
