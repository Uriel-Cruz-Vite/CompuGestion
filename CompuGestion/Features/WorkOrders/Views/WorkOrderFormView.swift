//
//  WorkOrdersFormView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI
import SwiftData

struct WorkOrderFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var viewModel: WorkOrderFormViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Título dinámico (crear vs editar)
            Text(viewModel.title)
                .font(.title2)
                .bold()

            Form {
                Section("Cliente") {
                    TextField("Nombre del cliente", text: $viewModel.customerName)
                }

                Section("Equipo") {
                    TextField(
                        "Descripción del equipo (ej: Laptop HP, PC Gamer)",
                        text: $viewModel.deviceDescription
                    )
                }

                Section("Descripción del problema") {
                    TextEditor(text: $viewModel.problemDescription)
                        .frame(minHeight: 80)
                }

                Section("Estado de la orden") {
                    Picker("Estado", selection: $viewModel.status) {
                        ForEach(WorkOrderStatus.allCases) { status in
                            Text(status.localizedTitle)
                                .tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Costo estimado (MXN)") {
                    TextField("Ej. 1500", text: $viewModel.estimatedCostText)
                        .textFieldStyle(.roundedBorder)
                        // .keyboardType(.decimalPad) // iOS-only; not available on macOS
                        .onChange(of: viewModel.estimatedCostText) { _, newValue in
                            // Simple macOS-friendly numeric filtering:
                            // allow digits and at most one decimal separator (.)
                            let filtered = filterToDecimalString(newValue)
                            if filtered != newValue {
                                viewModel.estimatedCostText = filtered
                            }
                        }
                }
            }

            HStack {
                Spacer()

                Button("Cancelar") {
                    dismiss()
                }

                Button("Guardar") {
                    do {
                        try viewModel.save(in: modelContext)
                        dismiss()
                    } catch {
                        print("Error al guardar:", error.localizedDescription)
                    }
                }
                .disabled(!viewModel.canSave)
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 520)
    }

    // MARK: - Helpers

    private func filterToDecimalString(_ input: String) -> String {
        // Keep digits and a single dot. You can adapt for locale if needed.
        var result = ""
        var hasDot = false
        for ch in input {
            if ch.isNumber {
                result.append(ch)
            } else if ch == "." && !hasDot {
                result.append(ch)
                hasDot = true
            }
        }
        return result
    }
}
