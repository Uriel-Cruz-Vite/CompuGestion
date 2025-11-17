//
//  AppRouter.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//
import SwiftUI

/// Router central para controlar la navegación y el estado actual de la pantalla
@Observable
class AppRouter {
    /// Ruta actual seleccionada
    var current: Route = .dashboard

    /// Cambiar ruta
    func go(to route: Route) {
        current = route
    }
}
