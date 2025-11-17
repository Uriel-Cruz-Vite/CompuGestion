//
//  FilterWorkOrderUseCasa.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//
import Foundation
import SwiftData

/// Criterios de filtrado para órdenes de trabajo.
struct WorkOrderFilter {
    var status: WorkOrderStatus? = nil
    var minDate: Date? = nil
    var maxDate: Date? = nil
    var searchText: String? = nil
}

/// Caso de uso para obtener órdenes filtradas desde SwiftData.
struct FilterWorkOrdersUseCase {

    func execute(
        filter: WorkOrderFilter,
        in context: ModelContext
    ) throws -> [WorkOrder] {

        var predicates: [Predicate<WorkOrder>] = []

        // Filtro por estado
        if let status = filter.status {
            predicates.append(#Predicate<WorkOrder> { $0.statusRaw == status.rawValue })
        }

        // Filtro por fecha mínima
        if let min = filter.minDate {
            predicates.append(#Predicate<WorkOrder> { $0.createdAt >= min })
        }

        // Filtro por fecha máxima
        if let max = filter.maxDate {
            predicates.append(#Predicate<WorkOrder> { $0.createdAt <= max })
        }

        // Combinar predicados
        let finalPredicate: Predicate<WorkOrder>? = {
            switch predicates.count {
            case 0:
                return nil
            case 1:
                return predicates.first
            default:
                return predicates.dropFirst().reduce(predicates.first!) { partial, next in
                    #Predicate<WorkOrder> { order in
                        partial.evaluate(order) && next.evaluate(order)
                    }
                }
            }
        }()

        // Ejecutar fetch con predicate o sin él
        let descriptor = FetchDescriptor<WorkOrder>(
            predicate: finalPredicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        var results = try context.fetch(descriptor)

        // Filtro por texto manual (case insensitive)
        if let text = filter.searchText,
           !text.trimmingCharacters(in: .whitespaces).isEmpty
        {
            let lower = text.lowercased()
            results = results.filter { order in
                order.customerName.lowercased().contains(lower)
                || order.deviceDescription.lowercased().contains(lower)
                || order.problemDescription.lowercased().contains(lower)
            }
        }

        Logger.log("FilterWorkOrdersUseCase devolvió \(results.count) órdenes.")
        return results
    }
}
