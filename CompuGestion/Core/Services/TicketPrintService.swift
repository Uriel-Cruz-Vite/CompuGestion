//
//  TicketPrintService.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 23/11/25.
//

import Foundation
import SwiftData
import PDFKit
import AppKit

/// Servicio para imprimir tickets en una impresora de tickets (80mm)
final class TicketPrintService {

    static let shared = TicketPrintService()

    private init() {}

    /// Genera el ticket en PDF y abre el diálogo de impresión.
    func printTicket(for invoice: Invoice, in context: ModelContext) {
        do {
            // 1. Generar el PDF del ticket
            let url = try PDFGeneratorService.shared.generateTicket(for: invoice, in: context)

            // 2. Verificar impresoras disponibles
            let printerNames = NSPrinter.printerNames

            guard !printerNames.isEmpty else {
                Logger.error("No hay impresoras configuradas en el sistema. Abriendo ticket en Vista Previa.")
                // Como fallback, abrimos el PDF para que el usuario pueda guardarlo / imprimirlo manualmente
                NSWorkspace.shared.open(url)
                return
            }

            guard let pdfDocument = PDFDocument(url: url) else {
                Logger.error("No se pudo cargar el PDF del ticket.")
                return
            }

            // 3. Crear un PDFView como contenido a imprimir
            let pdfView = PDFView()
            pdfView.document = pdfDocument
            pdfView.autoScales = true

            // 4. Configurar la info de impresión
            let printInfo = NSPrintInfo.shared.copy() as! NSPrintInfo

            // Tamaño aproximado de ticket 80mm (ancho 226 pts) x alto variable
            printInfo.paperSize = NSSize(width: 226, height: 600)
            printInfo.orientation = .portrait

            // Márgenes pequeños
            printInfo.leftMargin = 4
            printInfo.rightMargin = 4
            printInfo.topMargin = 4
            printInfo.bottomMargin = 4

            printInfo.horizontalPagination = .fit
            printInfo.verticalPagination = .fit
            printInfo.isVerticallyCentered = false
            printInfo.isHorizontallyCentered = true

            // Seleccionar impresora configurada (si existe)
            if let settings = try? SettingsService.shared.currentSettings(in: context),
               !settings.ticketPrinterName.isEmpty,
               let printer = NSPrinter(name: settings.ticketPrinterName) {
                printInfo.printer = printer
            }

            // 5. Crear la operación de impresión
            let operation = NSPrintOperation(view: pdfView, printInfo: printInfo)
            operation.showsPrintPanel = true      // muestra el diálogo de impresión
            operation.showsProgressPanel = true   // muestra progreso

            // 6. Ejecutar
            operation.run()

        } catch {
            Logger.error("Error al generar/imprimir ticket: \(error.localizedDescription)")
        }
    }
}
