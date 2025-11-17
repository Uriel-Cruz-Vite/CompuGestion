import SwiftUI
import SwiftData

struct WorkOrderFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var viewModel: WorkOrderFormViewModel

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

            // MARK: - Contenido scrollable (una sola columna)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Cliente
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cliente")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Nombre del cliente", text: $viewModel.customerName)
                    }

                    // Equipo
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Equipo")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField(
                            "Descripción del equipo (ej. Laptop HP, PC Gamer)",
                            text: $viewModel.deviceDescription
                        )
                    }

                    // Estado
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Estado")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        // Picker en estilo menú para que no ocupe todo el ancho
                        Picker("Estado", selection: $viewModel.status) {
                            ForEach(WorkOrderStatus.allCases) { status in
                                Text(status.localizedTitle)
                                    .tag(status)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    // Costo estimado
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Costo estimado (MXN)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack {
                            TextField("Ej. 1500", text: $viewModel.estimatedCostText)
                                .textFieldStyle(.roundedBorder)

                            Text("MXN")
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Descripción del problema
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Descripción del problema")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $viewModel.problemDescription)
                            .frame(minHeight: 120)
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
                        Logger.error("Error al guardar orden: \(error.localizedDescription)")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        // Ancho mínimo razonable para macOS, pero no exagerado
        .frame(minWidth: 420, minHeight: 380)
    }
}
