//
//  RootSceneView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI
import SwiftData

// Rutas principales de la app
enum AppRoute: String, Hashable, Identifiable, CaseIterable {
    case dashboard
    case customers
    case devices
    case workOrders
    case inventory
    case billing
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dashboard:  return "Dashboard"
        case .customers:  return "Clientes"
        case .devices:    return "Equipos"
        case .workOrders: return "Órdenes"
        case .inventory:  return "Inventario"
        case .billing:    return "Facturación"
        case .settings:   return "Configuración"
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard:  return "rectangle.grid.2x2"
        case .customers:  return "person.2"
        case .devices:    return "desktopcomputer"
        case .workOrders: return "wrench.and.screwdriver"
        case .inventory:  return "shippingbox"
        case .billing:    return "creditcard"
        case .settings:   return "gearshape"
        }
    }
}

struct RootSceneView: View {
    @Environment(\.modelContext) private var modelContext

    // Autenticación / sesión
    @State private var authViewModel = AuthViewModel()

    // Ruta seleccionada en el sidebar
    @State private var selection: AppRoute?

    // Rutas permitidas según rol
    private var allowedRoutes: [AppRoute] {
        if authViewModel.isAdmin {
            return AppRoute.allCases
        } else if authViewModel.isCashier {
            // Cajero: solo ventas
            return [.billing]
        } else {
            return []
        }
    }

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                NavigationSplitView {
                    sidebar
                } detail: {
                    detailContent
                }
                .navigationSplitViewStyle(.balanced)
                .onAppear {
                    // Asegura selección inicial según rol al entrar logueado
                    ensureValidSelection()
                }
                .onChange(of: authViewModel.isLoggedIn) { _, _ in
                    // Cuando cambia el estado de login, ajustamos selección
                    ensureValidSelection()
                }
            } else {
                // Pantalla de login
                LoginView(authViewModel: authViewModel)
            }
        }
        .task {
            // Seed de admin inicial (solo una vez)
            authViewModel.initialize(in: modelContext)
        }
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        List(selection: $selection) {
            if authViewModel.isAdmin {
                Section("Principal") {
                    sidebarItem(.dashboard)
                }
            }

            if authViewModel.isAdmin {
                Section("Gestión") {
                    sidebarItem(.customers)
                    sidebarItem(.devices)
                    sidebarItem(.workOrders)
                    sidebarItem(.inventory)
                }
            }

            Section("Caja") {
                // Disponible para admin y cajero
                sidebarItem(.billing)
            }

            if authViewModel.isAdmin {
                Section("Configuración") {
                    sidebarItem(.settings)
                }
            }

            Section("Cuenta") {
                Button {
                    authViewModel.logout()
                } label: {
                    Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Repair Manager")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                if let user = authViewModel.currentUser {
                    HStack(spacing: 6) {
                        Image(systemName: "person.circle")
                        VStack(alignment: .leading, spacing: 2) {
                            Text(user.username)
                                .font(.caption)
                            Text(user.role.localizedName)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func sidebarItem(_ route: AppRoute) -> some View {
        // Oculta cualquier ruta que no esté permitida por rol
        if allowedRoutes.contains(route) {
            NavigationLink(value: route) {
                Label(route.title, systemImage: route.systemImage)
            }
        }
    }

    // MARK: - Detail

    @ViewBuilder
    private var detailContent: some View {
        // Si por alguna razón selection no es válida para el rol, corregimos
        if let selection, allowedRoutes.contains(selection) {
            switch selection {
            case .dashboard:
                DashboardView()

            case .customers:
                CustomersListView()

            case .workOrders:
                WorkOrdersListView()

            case .inventory:
                InventoryListView()

            case .billing:
                BillingListView()

            case .settings:
                SettingsView()

            @unknown default:
                DashboardView()
            }
        } else {
            // Fallback según rol
            if authViewModel.isCashier {
                BillingListView()
            } else {
                DashboardView()
            }
        }
    }

    // MARK: - Helpers

    /// Asegura que la selección actual sea válida según el rol
    private func ensureValidSelection() {
        // Si no hay usuario logueado, limpiamos selección
        guard authViewModel.isLoggedIn else {
            selection = nil
            return
        }

        // Admin: default Dashboard
        if authViewModel.isAdmin {
            if selection == nil || !allowedRoutes.contains(selection!) {
                selection = .dashboard
            }
            return
        }

        // Cajero: solo facturación
        if authViewModel.isCashier {
            selection = .billing
            return
        }
    }
}
