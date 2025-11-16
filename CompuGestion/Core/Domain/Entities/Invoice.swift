//
//  Invoice.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import SwiftData

/// Representa una factura o comprobante de cobro
/// asociada a una orden de trabajo.
@Model
class Invoice {
    @Attribute(.unique) var id: UUID

    /// Número de factura o folio interno
    var invoiceNumber: String

    /// Relación con la orden de trabajo (opcional por si se genera después)
    @Relationship
    var workOrder: WorkOrder?

    /// Fecha de emisión
    var issueDate: Date

    /// Subtotal (antes de impuestos)
    var subtotal: Double

    /// Impuestos (IVA u otros)
    var taxAmount: Double

    /// Total (subtotal + impuestos)
    var total: Double

    /// Indica si está pagada o pendiente
    var isPaid: Bool

    /// Método de pago (texto libre: efectivo, tarjeta, transferencia, etc.)
    var paymentMethod: String?

    /// Notas adicionales
    var notes: String?

    init(
        id: UUID = UUID(),
        invoiceNumber: String,
        workOrder: WorkOrder? = nil,
        issueDate: Date = Date(),
        subtotal: Double,
        taxAmount: Double,
        total: Double,
        isPaid: Bool = false,
        paymentMethod: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.invoiceNumber = invoiceNumber
        self.workOrder = workOrder
        self.issueDate = issueDate
        self.subtotal = subtotal
        self.taxAmount = taxAmount
        self.total = total
        self.isPaid = isPaid
        self.paymentMethod = paymentMethod
        self.notes = notes
    }
}
