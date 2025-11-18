//
//  RootSceneView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI

/// Vista raíz de la aplicación, con sidebar y área de contenido.
struct RootSceneView: View {

    /// Opciones del sidebar
    private enum SidebarItem: Hashable {
        case dashboard
        case workOrders
        case customers
        case inventory
        case billing
        case settings

        var title: String {
            switch self {
            case .dashboard:  return "Dashboard"
            case .workOrders: return "Órdenes de trabajo"
            case .customers:  return "Clientes"
            case .inventory:  return "Inventario"
            case .billing:    return "Facturación"
            case .settings:   return "Configuración"
            }
        }

        var systemImage: String {
            switch self {
            case .dashboard:  return "rectangle.grid.2x2"
            case .workOrders: return "wrench.and.screwdriver"
            case .customers:  return "person.3"
            case .inventory:  return "shippingbox"
            case .billing:    return "creditcard"
            case .settings:   return "gearshape"
            }
        }
    }

    @State private var selection: SidebarItem? = .dashboard

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section("Principal") {
                    sidebarRow(.dashboard)
                    sidebarRow(.workOrders)
                    sidebarRow(.customers)
                    sidebarRow(.inventory)
                    sidebarRow(.billing)
                }

                Section("Sistema") {
                    sidebarRow(.settings)
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Repair Manager")
        } detail: {
            switch selection ?? .dashboard {
            case .dashboard:
                DashboardView()

            case .workOrders:
                WorkOrdersListView()

            case .customers:
                CustomersListView()

            case .inventory:
                InventoryListView()
                
            case .billing:
                BillingListView()
                
            case .settings:
                SettingsView()
            }
        }
    }

    // MARK: - Helper para filas del sidebar

    @ViewBuilder
    private func sidebarRow(_ item: SidebarItem) -> some View {
        Label(item.title, systemImage: item.systemImage)
            .tag(item)
    }
}
