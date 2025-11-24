//
//  BillingListView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI
import SwiftData
import AppKit

struct BillingListView: View {
    @Environment(\.modelContext) private var modelContext

    // Todas las facturas desde SwiftData, más recientes primero
    @Query(sort: \Invoice.issueDate, order: .reverse)
    private var invoices: [Invoice]

    @State private var viewModel = BillingListViewModel()

    // Servicio para imprimir tickets
    private let ticketPrintService = TicketPrintService.shared

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Barra superior
            HStack(spacing: 12) {
                SearchBar(text: $viewModel.searchText, placeholder: "Buscar factura o cliente")

                Menu {
                    Button("Todas") {
                        viewModel.setPaidFilter(nil)
                    }
                    Button("Pagadas") {
                        viewModel.setPaidFilter(true)
                    }
                    Button("Pendientes") {
                        viewModel.setPaidFilter(false)
                    }
                } label: {
                    HStack {
                        Text(filterTitle)
                        Image(systemName: "chevron.down")
                    }
                }

                Spacer()
                // No añadimos "Nueva factura": las facturas se generan desde Órdenes de trabajo
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            // MARK: - Lista
            let items = viewModel.filteredItems(from: invoices)

            if items.isEmpty {
                EmptyStateView(
                    title: "Sin facturas",
                    message: invoices.isEmpty
                        ? "Aún no has generado facturas. Puedes comenzar desde las órdenes de trabajo."
                        : "No se encontraron facturas que coincidan con tu búsqueda / filtro.",
                    systemImage: "doc.text"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(items) { item in
                        if let invoice = invoices.first(where: { $0.persistentModelID == item.id }) {
                            HStack(alignment: .top, spacing: 12) {

                                // Ícono
                                Image(systemName: "doc.text")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.secondary)

                                // Info principal
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(item.invoiceNumber)
                                            .font(.headline)
                                        if item.isPaid {
                                            TagPill(
                                                text: "Pagada",
                                                color: .green.opacity(0.85),
                                                systemImage: "checkmark.circle.fill"
                                            )
                                        } else {
                                            TagPill(
                                                text: "Pendiente",
                                                color: .orange.opacity(0.9),
                                                systemImage: "clock.fill"
                                            )
                                        }
                                    }

                                    Text(item.customerName)
                                        .font(.subheadline)

                                    Text("Emitida: \(item.issueDateText)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                // Total + acción rápida de ticket
                                VStack(alignment: .trailing, spacing: 6) {
                                    Text(item.totalText)
                                        .font(.headline)

                                    if !item.isPaid {
                                        Text("Por cobrar")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Button {
                                        ticketPrintService.printTicket(for: invoice, in: modelContext)
                                    } label: {
                                        Label("Ticket", systemImage: "printer")
                                            .font(.caption)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            .padding(.vertical, 4)
                            .contextMenu {
                                Button(item.isPaid ? "Marcar como pendiente" : "Marcar como pagada") {
                                    viewModel.togglePaid(invoice, in: modelContext)
                                }

                                Button("Imprimir ticket") {
                                    ticketPrintService.printTicket(for: invoice, in: modelContext)
                                }

                                Button(role: .destructive) {
                                    viewModel.delete(invoice, in: modelContext)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Facturación")
    }

    // MARK: - Helpers

    private var filterTitle: String {
        switch viewModel.paidFilter {
        case nil:    return "Todas"
        case true:   return "Pagadas"
        case false:  return "Pendientes"
        }
    }
}

