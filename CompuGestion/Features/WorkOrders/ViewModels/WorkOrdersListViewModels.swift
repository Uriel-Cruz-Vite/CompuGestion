//
//  WorkOrdersListViewModels.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import Observation
import SwiftData

/// ViewModel para la lista de órdenes de trabajo.
/// No hace fetch directo: recibe las órdenes (SwiftData @Query) desde la vista
/// y aplica filtros, búsquedas y formateos.
@Observable
class WorkOrdersListViewModel {

    // Texto de búsqueda (cliente/equipo)
    var searchText: String = ""

    // Filtro por estado (o nil = todos)
    var selectedStatus: WorkOrderStatus? = nil

    // Formateadores reutilizables
    private let dateFormatter: DateFormatter
    private let costFormatter: NumberFormatter

    init() {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        self.dateFormatter = df

        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencyCode = "MXN"
        self.costFormatter = nf
    }

    /// Aplica filtros y genera una vista de datos lista para mostrar en UI.
    func filteredOrders(from orders: [WorkOrder]) -> [WorkOrder] {
        orders.filter { order in
            var matches = true

            if let status = selectedStatus {
                matches = matches && (order.status == status)
            }

            if !searchText.isEmpty {
                let text = searchText.lowercased()
                let inCustomer = order.customerName.lowercased().contains(text)
                let inDevice = order.deviceDescription.lowercased().contains(text)
                matches = matches && (inCustomer || inDevice)
            }

            return matches
        }
    }

    func setStatusFilter(_ status: WorkOrderStatus?) {
        selectedStatus = status
    }

    // MARK: - Presentación / helpers

    func formattedDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    func formattedCost(_ cost: Double) -> String {
        costFormatter.string(from: NSNumber(value: cost)) ?? "$0.00"
    }

    // MARK: - Acciones con SwiftData

    /// Elimina una orden usando el ModelContext que le pasa la vista.
    func delete(order: WorkOrder, in context: ModelContext) {
        context.delete(order)
        try? context.save()
    }
}
