//
//  CustomerFormView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//
import SwiftUI
import SwiftData

struct CustomerFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var viewModel: CustomerFormViewModel

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

                    // Nombre
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Nombre completo del cliente", text: $viewModel.name)
                    }

                    // Teléfono
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Teléfono")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Teléfono de contacto", text: $viewModel.phone)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Correo electrónico
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Correo electrónico")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("ejemplo@correo.com", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Dirección
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dirección")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Calle, número, colonia, ciudad", text: $viewModel.address)
                            .textFieldStyle(.roundedBorder)
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
                        Logger.error("Error al guardar cliente: \(error.localizedDescription)")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(minWidth: 420, minHeight: 340)
    }
}
