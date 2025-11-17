//
//  BillingListViewModel.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//
import Foundation
import Observation
import SwiftData

/// ViewModel para la lista de facturas (Invoice).
@Observable
class BillingListViewModel {

    /// Búsqueda por número de factura, cliente, etc.
    var searchText: String = ""

    /// Filtro de estado de pago: nil = todos, true = pagadas, false = pendientes
    var paidFilter: Bool? = nil

    // MARK: - Filtrado y mapeo

    func filteredItems(from invoices: [Invoice]) -> [InvoiceListItem] {
        let filtered = invoices.filter { invoice in
            var matches = true

            // Filtro por estado de pago
            if let paidFilter {
                matches = matches && (invoice.isPaid == paidFilter)
            }

            // Filtro por texto
            if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                let text = searchText.lowercased()

                let inNumber = invoice.invoiceNumber.lowercased().contains(text)
                let inCustomer = invoice.workOrder?.customerName.lowercased().contains(text) ?? false

                matches = matches && (inNumber || inCustomer)
            }

            return matches
        }

        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none

        return filtered.map { invoice in
            let issueDateText = df.string(from: invoice.issueDate)

            let formatter = NumberFormatter.currencyMXN
            let totalText = formatter.string(from: NSNumber(value: invoice.total)) ?? "$0.00"

            let customerName = invoice.workOrder?.customerName ?? "Sin cliente"

            return InvoiceListItem(
                id: invoice.persistentModelID,
                invoiceNumber: invoice.invoiceNumber,
                customerName: customerName,
                issueDateText: issueDateText,
                totalText: totalText,
                isPaid: invoice.isPaid
            )
        }
    }

    // MARK: - Acciones con SwiftData

    func togglePaid(_ invoice: Invoice, in context: ModelContext) {
        invoice.isPaid.toggle()
        try? context.save()
    }

    func delete(_ invoice: Invoice, in context: ModelContext) {
        context.delete(invoice)
        try? context.save()
    }

    // MARK: - Filtros UI

    func setPaidFilter(_ paid: Bool?) {
        paidFilter = paid
    }
}
