//
//  User.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation
import SwiftData

/// Representa un usuario del sistema (técnico, administrador, etc.)
@Model
class User {
    @Attribute(.unique) var id: UUID

    /// Nombre completo
    var fullName: String

    /// Correo electrónico (opcional)
    var email: String?

    /// Rol del usuario (técnico, admin, etc.)
    var roleRaw: String

    /// Fecha de creación del usuario
    var createdAt: Date

    /// Último inicio de sesión
    var lastLoginAt: Date?

    // MARK: - Computed para trabajar con enum tipado
    var role: UserRole {
        get { UserRole(rawValue: roleRaw) ?? .technician }
        set { roleRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        fullName: String,
        email: String? = nil,
        role: UserRole = .technician,
        createdAt: Date = Date(),
        lastLoginAt: Date? = nil
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.roleRaw = role.rawValue
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
}

enum UserRole: String, Codable, CaseIterable, Identifiable {
    case admin
    case technician
    case manager

    var id: String { rawValue }

    var label: String {
        switch self {
        case .admin:      return "Administrador"
        case .technician: return "Técnico"
        case .manager:    return "Gerente"
        }
    }
}
