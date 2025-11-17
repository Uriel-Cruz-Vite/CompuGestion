//
//  InventoryFormView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI
import SwiftData

struct InventoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var viewModel: InventoryFormViewModel

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            HStack {
                Text(viewModel.title)
                    .font(.title3)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Divider()

            // MARK: - Contenido scrollable (una columna)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // SKU
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SKU / Código")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Ej. SSD-240-KINGSTON", text: $viewModel.sku)
                    }

                    // Nombre
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre del artículo")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Ej. Disco SSD 240GB Kingston", text: $viewModel.name)
                    }

                    // Categoría
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Categoría")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Ej. Almacenamiento, Memorias, Tarjetas madre…", text: $viewModel.category)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Cantidad y stock mínimo
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Stock")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Cantidad actual")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)

                                TextField("Ej. 10", text: $viewModel.quantityText)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(maxWidth: 80)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Stock mínimo")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)

                                TextField("Ej. 2", text: $viewModel.minimumStockText)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(maxWidth: 80)
                            }
                        }
                    }

                    // Costo unitario
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Costo unitario (MXN)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack {
                            TextField("Ej. 450", text: $viewModel.unitCostText)
                                .textFieldStyle(.roundedBorder)

                            Text("MXN")
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Ubicación
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ubicación")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Ej. Estante A2, cajón 3…", text: $viewModel.location)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Notas
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notas")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $viewModel.notes)
                            .frame(minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.3))
                            )
                    }

                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }

            Divider()

            // MARK: - Barra inferior (botones)
            HStack {
                Spacer()

                Button("Cancelar") {
                    dismiss()
                }

                PrimaryButton(
                    title: "Guardar",
                    systemImage: "checkmark",
                    isDisabled: !viewModel.canSave
                ) {
                    do {
                        try viewModel.save(in: modelContext)
                        dismiss()
                    } catch {
                        Logger.error("Error al guardar artículo de inventario: \(error.localizedDescription)")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(minWidth: 420, minHeight: 420)
    }
}
