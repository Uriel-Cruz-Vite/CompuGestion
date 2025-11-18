//
//  CompuGestionApp.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI
import SwiftData

@main
struct RepairManagerApp: App {

    var body: some Scene {
        WindowGroup {
            RootSceneView()
        }
        .modelContainer(for: [
            // Ajusta esta lista a los modelos que tengas en tu proyecto
            Customer.self,
            Device.self,
            WorkOrder.self,
            InventoryItem.self,
            Invoice.self,
            User.self,
            AppSettings.self      // 👈 IMPORTANTE: agregar AppSettings
        ])
    }
}
