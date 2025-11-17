//
//  InvoiceListItem.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//
import Foundation
import SwiftData

/// Modelo ligero para mostrar facturas en una lista.
/// Envuelve a `Invoice` sin exponer el objeto directamente.
struct InvoiceListItem: Identifiable {
    /// ID interno de SwiftData para localizar la `Invoice` original
    let id: PersistentIdentifier

    /// Número de factura / folio
    let invoiceNumber: String

    /// Nombre del cliente (si se puede derivar de la orden)
    let customerName: String

    /// Fecha de emisión formateada
    let issueDateText: String

    /// Total formateado (MXN)
    let totalText: String

    /// Estado de pago
    let isPaid: Bool
}
