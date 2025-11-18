//
//  WorkOrdersListView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI
import SwiftData

// Modo del formulario: nuevo o editar
private enum WorkOrderFormMode: Identifiable {
    case new
    case edit(WorkOrder)

    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit(let order):
            return String(describing: order.persistentModelID)
        }
    }
}

struct WorkOrdersListView: View {
    @Environment(\.modelContext) private var modelContext

    // Todas las órdenes desde SwiftData, ordenadas por fecha de creación (más recientes primero)
    @Query(sort: \WorkOrder.createdAt, order: .reverse)
    private var workOrders: [WorkOrder]

    @State private var viewModel = WorkOrdersListViewModel()

    // Estado del formulario (nuevo / editar)
    @State private var formMode: WorkOrderFormMode? = nil

    // Use case para facturas
    private let generateInvoiceUseCase = GenerateInvoiceUseCase()

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Barra superior: búsqueda y filtro
            HStack(spacing: 12) {
                SearchBar(text: $viewModel.searchText, placeholder: "Buscar cliente o equipo")

                Menu {
                    Button("Todos los estados") {
                        viewModel.setStatusFilter(nil)
                    }

                    ForEach(WorkOrderStatus.allCases) { status in
                        Button(status.localizedTitle) {
                            viewModel.setStatusFilter(status)
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedStatus?.localizedTitle ?? "Estado: Todos")
                        Image(systemName: "chevron.down")
                    }
                }
                .menuStyle(.borderlessButton)

                Spacer()

                Button {
                    // Nueva orden
                    formMode = .new
                } label: {
                    Label("Nueva orden", systemImage: "plus")
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            // MARK: - Contenido principal
            let filtered = viewModel.filteredOrders(from: workOrders)

            if filtered.isEmpty {
                EmptyStateView(
                    title: "No hay órdenes para mostrar.",
                    message: "Crea una nueva orden o ajusta la búsqueda / filtros.",
                    systemImage: "wrench.and.screwdriver"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 👇 ScrollView + LazyVStack en vez de List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(filtered, id: \.persistentModelID) { order in
                            orderRow(order)
                                .id(order.persistentModelID)
                            Divider()
                        }
                    }
                }
            }
        }
        .navigationTitle("Órdenes de trabajo")
        // MARK: - Sheet para crear / editar, basado en item (mode)
        .sheet(item: $formMode) { mode in
            switch mode {
            case .new:
                WorkOrderFormView(viewModel: WorkOrderFormViewModel())
            case .edit(let order):
                WorkOrderFormView(viewModel: WorkOrderFormViewModel(order: order))
            }
        }
    }

    // MARK: - Fila de orden

    @ViewBuilder
    private func orderRow(_ order: WorkOrder) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(order.customerName)
                    .font(.headline)

                Text(order.deviceDescription)
                    .font(.subheadline)

                Text(order.status.localizedTitle)
                    .font(.caption)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 6)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(6)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.formattedCost(order.estimatedCost))
                    .font(.headline)

                Text(viewModel.formattedDate(order.createdAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            // Editar al tocar la fila
            formMode = .edit(order)
        }
        .contextMenu {
            // EDITAR
            Button("Editar") {
                formMode = .edit(order)
            }

            // GENERAR FACTURA solo cuando está listo o entregado
            let canGenerateInvoice =
                order.status == .ready || order.status == .delivered

            Button("Generar factura") {
                if canGenerateInvoice {
                    generateInvoice(for: order)
                }
            }
            .disabled(!canGenerateInvoice)

            // ELIMINAR
            Button(role: .destructive) {
                viewModel.delete(order: order, in: modelContext)
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
        }
    }

    // MARK: - Facturación

    private func generateInvoice(for order: WorkOrder) {
        do {
            _ = try generateInvoiceUseCase.execute(
                for: order,
                taxRate: 0.16,
                markAsPaid: false,
                in: modelContext
            )
            Logger.success("Factura generada desde la lista para \(order.customerName)")
        } catch {
            Logger.error("Error al generar factura: \(error.localizedDescription)")
        }
    }
}
