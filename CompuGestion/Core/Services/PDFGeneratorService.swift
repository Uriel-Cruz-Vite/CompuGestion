//
//  PDFGeneratorService.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//
import Foundation
import PDFKit
import SwiftData
import AppKit

/// Servicio para generar PDFs (tickets, facturas, etc.)
final class PDFGeneratorService {

    static let shared = PDFGeneratorService()

    private init() {}

    // MARK: - Ticket de compra (desde una factura)

    /// Genera un PDF tipo ticket para la factura indicada usando la configuración del negocio.
    ///
    /// - Parameters:
    ///   - invoice: Factura de la que se generará el ticket.
    ///   - context: ModelContext para leer AppSettings.
    /// - Returns: URL del archivo PDF generado en una carpeta temporal.
    func generateTicket(for invoice: Invoice, in context: ModelContext) throws -> URL {
        // Leer configuración del negocio
        let settings = try SettingsService.shared.currentSettings(in: context)

        let pdf = PDFDocument()

        // Página tamaño ticket (80mm x 200mm aprox)
        let pageWidth: CGFloat = 226 // ~80mm en puntos
        let pageHeight: CGFloat = 600

        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let ticketImage = renderTicketImage(for: invoice,
                                            settings: settings,
                                            size: pageRect.size)

        guard let pdfPage = PDFPage(image: ticketImage) else {
            throw NSError(
                domain: "PDFGeneratorService",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "No se pudo crear la página PDF."]
            )
        }

        pdf.insert(pdfPage, at: 0)

        // Guardar en archivo temporal
        let tempDir = FileManager.default.temporaryDirectory
        let filename = "Ticket-\(invoice.invoiceNumber).pdf"
        let fileURL = tempDir.appendingPathComponent(filename)

        if pdf.write(to: fileURL) {
            return fileURL
        } else {
            throw NSError(
                domain: "PDFGeneratorService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No se pudo escribir el archivo PDF."]
            )
        }
    }

    // MARK: - Render del contenido como imagen para la página PDF

    private func renderTicketImage(
        for invoice: Invoice,
        settings: AppSettings,
        size: CGSize
    ) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        let context = NSGraphicsContext.current?.cgContext
        context?.setFillColor(NSColor.white.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))

        // Márgenes
        let margin: CGFloat = 12
        var currentY = size.height - margin

        func draw(_ text: String,
                  font: NSFont = .systemFont(ofSize: 10),
                  weight: NSFont.Weight = .regular,
                  align: NSTextAlignment = .left,
                  spacing: CGFloat = 4) {

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = align

            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: font.pointSize, weight: weight),
                .paragraphStyle: paragraph
            ]

            let attrString = NSAttributedString(string: text, attributes: attributes)
            let maxWidth = size.width - (margin * 2)
            let bounding = attrString.boundingRect(
                with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading]
            )

            currentY -= bounding.height
            let rect = CGRect(
                x: margin,
                y: currentY,
                width: maxWidth,
                height: bounding.height
            )
            attrString.draw(in: rect)
            currentY -= spacing
        }

        // Datos del negocio desde AppSettings
        draw(settings.businessName.isEmpty ? "Mi taller de reparación" : settings.businessName,
             font: .systemFont(ofSize: 12),
             weight: .bold,
             align: .center,
             spacing: 2)

        if !settings.taxId.isEmpty {
            draw("RFC: \(settings.taxId)",
                 font: .systemFont(ofSize: 9),
                 weight: .regular,
                 align: .center,
                 spacing: 1)
        }

        if !settings.address.isEmpty {
            draw(settings.address,
                 font: .systemFont(ofSize: 9),
                 weight: .regular,
                 align: .center,
                 spacing: 1)
        }

        if !settings.phone.isEmpty || !settings.email.isEmpty {
            var contact = ""
            if !settings.phone.isEmpty { contact += "Tel: \(settings.phone)" }
            if !settings.email.isEmpty {
                if !contact.isEmpty { contact += " | " }
                contact += settings.email
            }
            draw(contact,
                 font: .systemFont(ofSize: 9),
                 weight: .regular,
                 align: .center,
                 spacing: 6)
        } else {
            currentY -= 4
        }

        draw("Ticket de compra",
             font: .systemFont(ofSize: 11),
             weight: .medium,
             align: .center,
             spacing: 8)

        draw("--------------------------------", align: .center, spacing: 4)

        // Datos de la factura
        draw("Factura: \(invoice.invoiceNumber)", weight: .medium)
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        draw("Fecha: \(df.string(from: invoice.issueDate))")

        if let order = invoice.workOrder {
            draw("Cliente: \(order.customerName)")
            draw("Equipo: \(order.deviceDescription)")
        }

        draw("--------------------------------", align: .center, spacing: 4)

        // Totales
        let formatter = NumberFormatter.currencyMXN
        let subtotalText = formatter.string(from: NSNumber(value: invoice.subtotal)) ?? "$0.00"
        let taxText = formatter.string(from: NSNumber(value: invoice.taxAmount)) ?? "$0.00"
        let totalText = formatter.string(from: NSNumber(value: invoice.total)) ?? "$0.00"

        draw("Subtotal: \(subtotalText)")
        draw("Impuestos: \(taxText)")
        draw("TOTAL: \(totalText)", weight: .bold, spacing: 8)

        draw("--------------------------------", align: .center, spacing: 8)

        draw("Gracias por su compra.", align: .center)

        image.unlockFocus()
        return image
    }
}
