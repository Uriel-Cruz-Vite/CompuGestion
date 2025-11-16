//
//  RootSceneView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI

struct RootSceneView: View {
    var body: some View {
        NavigationSplitView {
            List {
                // Menú principal
                NavigationLink("Dashboard") {
                    Text("Dashboard pendiente…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                NavigationLink("Órdenes de trabajo") {
                    WorkOrdersListView()
                }

                NavigationLink("Clientes") {
                    Text("Clientes pendiente…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                NavigationLink("Inventario") {
                    Text("Inventario pendiente…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                NavigationLink("Configuración") {
                    SettingsView()
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Repair Manager")
        } detail: {
            // Aquí se muestra el contenido inicial
            Text("Selecciona una sección en la barra lateral")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
