//
//  ModelContainerConfig.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftData

/// Configuración central de SwiftData para toda la app.
enum ModelContainerConfig {

    /// ModelContainer que se inyecta en RepairManagerApp
    static let container: ModelContainer = {
        do {
            // Esquema de modelos de dominio que usarán SwiftData
            let schema = Schema([
                Customer.self,
                Device.self,
                WorkOrder.self,
                InventoryItem.self,
                Invoice.self,
                User.self
            ])

            // Configuración por defecto (puede apuntar a un archivo en disco)
            let configuration = ModelConfiguration(schema: schema)

            let container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )

            return container
        } catch {
            // Si algo falla al crear el container, es crítico:
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }()
}
