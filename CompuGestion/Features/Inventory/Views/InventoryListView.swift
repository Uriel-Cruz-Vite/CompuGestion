//
//  InventoryListView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI
import SwiftData

struct InventoryListView: View {
    @Environment(\.modelContext) private var modelContext

    // Trae todos los items de inventario desde SwiftData
    @Query(sort: \InventoryItem.name, order: .forward)
    private var inventoryItems: [InventoryItem]

    @State private var viewModel = InventoryListViewModel()

    // Sheet para crear / editar
    @State private var isShowingForm: Bool = false
    @State private var itemToEdit: InventoryItem? = nil

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Barra superior
            HStack(spacing: 12) {
                SearchBar(text: $viewModel.searchText, placeholder: "Buscar en inventario")

                Spacer()

                Button {
                    itemToEdit = nil
                    isShowingForm = true
                } label: {
                    Label("Nuevo artículo", systemImage: "plus")
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            // MARK: - Lista
            let items = viewModel.filteredItems(from: inventoryItems)

            if items.isEmpty {
                EmptyStateView(
                    title: "Inventario vacío",
                    message: inventoryItems.isEmpty
                        ? "Registra tu primer artículo para comenzar a controlar tus refacciones."
                        : "No se encontraron artículos que coincidan con tu búsqueda.",
                    systemImage: "shippingbox",
                    actionTitle: inventoryItems.isEmpty ? "Nuevo artículo" : nil
                ) {
                    itemToEdit = nil
                    isShowingForm = true
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(items) { item in
                        if let original = inventoryItems.first(where: { $0.persistentModelID == item.id }) {
                            HStack(alignment: .top, spacing: 12) {
                                // Icono
                                Image(systemName: "shippingbox")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.secondary)

                                // Info principal
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)

                                    HStack(spacing: 8) {
                                        Text(item.sku)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)

                                        if let category = item.category, !category.isEmpty {
                                            TagPill(
                                                text: category,
                                                color: .blue.opacity(0.8),
                                                systemImage: "tag.fill"
                                            )
                                        }
                                    }
                                }

                                Spacer()

                                // Cantidad y costo
                                VStack(alignment: .trailing, spacing: 4) {
                                    // Stock
                                    if item.isLowStock {
                                        TagPill(
                                            text: "Stock bajo (\(item.quantityText))",
                                            color: .red.opacity(0.85),
                                            systemImage: "exclamationmark.triangle.fill"
                                        )
                                    } else {
                                        TagPill(
                                            text: "Stock: \(item.quantityText)",
                                            color: .green.opacity(0.85),
                                            systemImage: "cube.box.fill"
                                        )
                                    }

                                    // Costo unitario
                                    Text("Costo: \(item.unitCostText)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                itemToEdit = original
                                isShowingForm = true
                            }
                            .contextMenu {
                                Button("Editar") {
                                    itemToEdit = original
                                    isShowingForm = true
                                }

                                Button(role: .destructive) {
                                    viewModel.delete(original, in: modelContext)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Inventario")
        // MARK: - Sheet para crear / editar
        .sheet(isPresented: $isShowingForm) {
            if let itemToEdit {
                InventoryFormView(
                    viewModel: InventoryFormViewModel(item: itemToEdit)
                )
            } else {
                InventoryFormView(
                    viewModel: InventoryFormViewModel()
                )
            }
        }
    }
}
