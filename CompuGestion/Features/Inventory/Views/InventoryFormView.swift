//
//  InventoryFormView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI
import SwiftData
import Observation

struct InventoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var viewModel: InventoryFormViewModel

    init(viewModel: InventoryFormViewModel) {
        self._viewModel = Bindable(viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Text(viewModel.title)
                    .font(.title3)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("SKU / Código")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Ej. SSD-240-KINGSTON", text: $viewModel.sku)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre del artículo")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Ej. Disco SSD 240GB Kingston", text: $viewModel.name)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Categoría")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Ej. Almacenamiento, Memorias…", text: $viewModel.category)
                            .textFieldStyle(.roundedBorder)
                    }

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

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ubicación")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Ej. Estante A2, cajón 3…", text: $viewModel.location)
                            .textFieldStyle(.roundedBorder)
                    }

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
