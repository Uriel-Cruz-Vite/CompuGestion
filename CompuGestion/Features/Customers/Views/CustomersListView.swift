//
//  CustomersListView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//
import SwiftUI
import SwiftData

struct CustomersListView: View {
    @Environment(\.modelContext) private var modelContext

    // Trae todos los clientes de SwiftData, ordenados por nombre
    @Query(sort: \Customer.name, order: .forward)
    private var customers: [Customer]

    @State private var viewModel = CustomersListViewModel()

    // Estado para el formulario (sheet)
    @State private var isShowingForm: Bool = false
    @State private var customerToEdit: Customer? = nil

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Barra superior
            HStack(spacing: 12) {
                SearchBar(text: $viewModel.searchText, placeholder: "Buscar cliente")

                Spacer()

                Button {
                    customerToEdit = nil
                    isShowingForm = true
                } label: {
                    Label("Nuevo cliente", systemImage: "person.badge.plus")
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            // MARK: - Lista
            let items = viewModel.filteredItems(from: customers)

            if items.isEmpty {
                EmptyStateView(
                    title: "No hay clientes registrados",
                    message: customers.isEmpty
                        ? "Agrega tu primer cliente para comenzar a registrar órdenes de trabajo."
                        : "No se encontraron clientes que coincidan con tu búsqueda.",
                    systemImage: "person.crop.circle.badge.questionmark",
                    actionTitle: customers.isEmpty ? "Nuevo cliente" : nil
                ) {
                    customerToEdit = nil
                    isShowingForm = true
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(items) { item in
                        if let customer = customers.first(where: { $0.persistentModelID == item.id }) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 28))
                                    .foregroundStyle(.secondary)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)

                                    HStack(spacing: 12) {
                                        if let phone = item.phone, !phone.isEmpty {
                                            Label(phone, systemImage: "phone.fill")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }

                                        if let email = item.email, !email.isEmpty {
                                            Label(email, systemImage: "envelope.fill")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }

                                Spacer()
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                customerToEdit = customer
                                isShowingForm = true
                            }
                            .contextMenu {
                                Button("Editar") {
                                    customerToEdit = customer
                                    isShowingForm = true
                                }

                                Button(role: .destructive) {
                                    viewModel.delete(customer, in: modelContext)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Clientes")
        // MARK: - Sheet para crear / editar cliente
        .sheet(isPresented: $isShowingForm) {
            if let customerToEdit {
                CustomerFormView(viewModel: CustomerFormViewModel(customer: customerToEdit))
            } else {
                CustomerFormView(viewModel: CustomerFormViewModel())
            }
        }
    }
}
