//
//  CustomerFormView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//
import SwiftUI
import SwiftData
import Observation

struct CustomerFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var viewModel: CustomerFormViewModel

    init(viewModel: CustomerFormViewModel) {
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

            // Contenido
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Nombre completo del cliente", text: $viewModel.name)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Teléfono")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Teléfono de contacto", text: $viewModel.phone)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Correo electrónico")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("ejemplo@correo.com", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                    }

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
