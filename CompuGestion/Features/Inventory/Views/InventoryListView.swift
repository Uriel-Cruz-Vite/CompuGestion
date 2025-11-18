//
//  InventoryListView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI
import SwiftData

// Modo del formulario: nuevo o editar artículo de inventario
private enum InventoryFormMode: Identifiable {
    case new
    case edit(InventoryItem)

    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit(let item):
            return String(describing: item.persistentModelID)
        }
    }
}

struct InventoryListView: View {
    @Environment(\.modelContext) private var modelContext

    // Trae todos los items de inventario desde SwiftData
    @Query(sort: \InventoryItem.name, order: .forward)
    private var inventoryItems: [InventoryItem]

    @State private var viewModel = InventoryListViewModel()

    // Estado del formulario (nuevo / editar)
    @State private var formMode: InventoryFormMode? = nil

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Barra superior
            HStack(spacing: 12) {
                SearchBar(text: $viewModel.searchText, placeholder: "Buscar en inventario")

                Spacer()

                Button {
                    formMode = .new
                } label: {
                    Label("Nuevo artículo", systemImage: "plus")
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            // MARK: - Contenido
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
                    formMode = .new
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 👇 ScrollView + LazyVStack en vez de List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(items) { item in
                            if let original = inventoryItems.first(where: { $0.persistentModelID == item.id }) {
                                inventoryRow(item: item, original: original)
                                    .id(item.id)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Inventario")
        // MARK: - Sheet para crear / editar
        .sheet(item: $formMode) { mode in
            switch mode {
            case .new:
                InventoryFormView(
                    viewModel: InventoryFormViewModel()
                )
            case .edit(let item):
                InventoryFormView(
                    viewModel: InventoryFormViewModel(item: item)
                )
            }
        }
    }

    // MARK: - Fila de inventario

    @ViewBuilder
    private func inventoryRow(item: InventoryListItem, original: InventoryItem) -> some View {
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

                Text("Costo: \(item.unitCostText)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            formMode = .edit(original)
        }
        .contextMenu {
            Button("Editar") {
                formMode = .edit(original)
            }

            Button(role: .destructive) {
                viewModel.delete(original, in: modelContext)
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
        }
    }
}
