//
//  WorkOrdersListView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI
import SwiftData

struct WorkOrdersListView: View {
    @Environment(\.modelContext) private var modelContext

    // Todas las órdenes desde SwiftData, ordenadas por fecha de creación (más recientes primero)
    @Query(sort: \WorkOrder.createdAt, order: .reverse)
    private var workOrders: [WorkOrder]

    @State private var viewModel = WorkOrdersListViewModel()

    // Estado para el formulario (sheet)
    @State private var isShowingForm: Bool = false
    @State private var orderToEdit: WorkOrder? = nil

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Barra superior: búsqueda y filtro
            HStack(spacing: 12) {
                TextField("Buscar cliente o equipo", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 240)

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
                    // Nueva orden: limpiamos orderToEdit y mostramos formulario
                    orderToEdit = nil
                    isShowingForm = true
                } label: {
                    Label("Nueva orden", systemImage: "plus")
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            // MARK: - Lista principal
            let filtered = viewModel.filteredOrders(from: workOrders)

            if filtered.isEmpty {
                VStack(spacing: 8) {
                    Text("No hay órdenes para mostrar.")
                        .font(.title3)

                    Text("Crea una nueva orden o ajusta la búsqueda / filtros.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(filtered) { order in
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
                        .padding(.vertical, 4)
                        .contentShape(Rectangle()) // Para que toda la fila sea clicable
                        .onTapGesture {
                            // Editar orden al tocar la fila
                            orderToEdit = order
                            isShowingForm = true
                        }
                        .contextMenu {
                            Button("Editar") {
                                orderToEdit = order
                                isShowingForm = true
                            }

                            Button(role: .destructive) {
                                viewModel.delete(order: order, in: modelContext)
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Órdenes de trabajo")
        // MARK: - Sheet para crear / editar
        .sheet(isPresented: $isShowingForm) {
            if let orderToEdit {
                WorkOrderFormView(
                    viewModel: WorkOrderFormViewModel(order: orderToEdit)
                )
            } else {
                WorkOrderFormView(
                    viewModel: WorkOrderFormViewModel()
                )
            }
        }
    }
}
