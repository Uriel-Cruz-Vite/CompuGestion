//
//  GenerateInvoiceUseCase.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation
import SwiftData

/// Caso de uso para generar una factura (Invoice) a partir de una orden de trabajo.
struct GenerateInvoiceUseCase {

    /// Genera y guarda una factura asociada a la orden.
    ///
    /// - Parameters:
    ///   - order: Orden de trabajo para la que se generará la factura.
    ///   - taxRate: Tasa de impuesto (por ejemplo 0.16 = 16% IVA).
    ///   - markAsPaid: Indica si la factura se crea ya marcada como pagada.
    ///   - context: `ModelContext` de SwiftData donde se guardará la factura.
    ///
    /// - Returns: La factura creada.
    func execute(
        for order: WorkOrder,
        taxRate: Double = 0.16,
        markAsPaid: Bool = false,
        in context: ModelContext
    ) throws -> Invoice {

        // Subtotal = costo estimado de la orden
        let subtotal = order.estimatedCost
        let taxAmount = subtotal * taxRate
        let total = subtotal + taxAmount

        let invoiceNumber = generateInvoiceNumber(for: order)

        let invoice = Invoice(
            invoiceNumber: invoiceNumber,
            workOrder: order,
            issueDate: Date(),
            subtotal: subtotal,
            taxAmount: taxAmount,
            total: total,
            isPaid: markAsPaid,
            paymentMethod: nil,
            notes: nil
        )

        context.insert(invoice)
        try context.save()

        Logger.success("Factura \(invoiceNumber) generada para orden de \(order.customerName)")
        return invoice
    }

    // MARK: - Helpers

    /// Genera un número de factura sencillo basado en fecha y hora.
    /// Ejemplo: "FAC-20251117-001234"
    private func generateInvoiceNumber(for order: WorkOrder) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        let datePart = formatter.string(from: Date())

        // Puedes personalizar el prefijo o incluir parte del UUID de la orden.
        return "FAC-\(datePart)"
    }
}
