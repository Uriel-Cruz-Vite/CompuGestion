//
//  Route.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation

/// Rutas posibles dentro de la aplicación.
/// Permite navegar de forma tipada y clara.
enum Route: Hashable {
    case dashboard
    case workOrders
    case customers
    case inventory
    case settings
}
