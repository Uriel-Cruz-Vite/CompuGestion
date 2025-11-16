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
        // ModelContainer central para toda la app
        .modelContainer(ModelContainerConfig.container)
    }
}
