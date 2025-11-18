//
//  CustomersListView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//
import SwiftUI
import SwiftData

// Modo del formulario: nuevo o editar cliente
private enum CustomerFormMode: Identifiable {
    case new
    case edit(Customer)

    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit(let customer):
            return String(describing: customer.persistentModelID)
        }
    }
}

struct CustomersListView: View {
    @Environment(\.modelContext) private var modelContext

    // Trae todos los clientes de SwiftData, ordenados por nombre
    @Query(sort: \Customer.name, order: .forward)
    private var customers: [Customer]

    @State private var viewModel = CustomersListViewModel()

    // Estado del formulario (nuevo / editar)
    @State private var formMode: CustomerFormMode? = nil

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Barra superior
            HStack(spacing: 12) {
                SearchBar(text: $viewModel.searchText, placeholder: "Buscar cliente")

                Spacer()

                Button {
                    formMode = .new
                } label: {
                    Label("Nuevo cliente", systemImage: "person.badge.plus")
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            // MARK: - Contenido
            let filtered = viewModel.filteredCustomers(from: customers)

            if filtered.isEmpty {
                EmptyStateView(
                    title: "No hay clientes registrados",
                    message: customers.isEmpty
                        ? "Agrega tu primer cliente para comenzar a registrar órdenes de trabajo."
                        : "No se encontraron clientes que coincidan con tu búsqueda.",
                    systemImage: "person.crop.circle.badge.questionmark",
                    actionTitle: customers.isEmpty ? "Nuevo cliente" : nil
                ) {
                    formMode = .new
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 👇 ScrollView + LazyVStack en vez de List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(filtered, id: \.persistentModelID) { customer in
                            customerRow(customer)
                                .id(customer.persistentModelID)
                            Divider()
                        }
                    }
                }
            }
        }
        .navigationTitle("Clientes")
        // MARK: - Sheet para crear / editar basado en item (mode)
        .sheet(item: $formMode) { mode in
            switch mode {
            case .new:
                CustomerFormView(
                    viewModel: CustomerFormViewModel()
                )
            case .edit(let customer):
                CustomerFormView(
                    viewModel: CustomerFormViewModel(customer: customer)
                )
            }
        }
    }

    // MARK: - Fila de cliente

    @ViewBuilder
    private func customerRow(_ customer: Customer) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle")
                .font(.system(size: 28))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .font(.headline)

                HStack(spacing: 12) {
                    if let phone = customer.phone, !phone.isEmpty {
                        Label(phone, systemImage: "phone.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if let email = customer.email, !email.isEmpty {
                        Label(email, systemImage: "envelope.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            formMode = .edit(customer)
        }
        .contextMenu {
            Button("Editar") {
                formMode = .edit(customer)
            }

            Button(role: .destructive) {
                viewModel.delete(customer, in: modelContext)
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
        }
    }
}
