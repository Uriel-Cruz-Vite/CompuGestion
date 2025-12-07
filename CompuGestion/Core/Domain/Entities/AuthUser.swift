//
//  AuthUser.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 07/12/25.
//
import Foundation
import SwiftData

/// Rol del usuario dentro del sistema (para login)
enum AppUserRole: String, Codable, CaseIterable, Identifiable {
    case admin
    case cashier

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .admin:   return "Administrador"
        case .cashier: return "Cajero"
        }
    }

    var description: String {
        switch self {
        case .admin:
            return "Puede acceder a todas las secciones, crear, editar y eliminar registros y configurar el sistema."
        case .cashier:
            return "Puede realizar ventas (facturación) y operaciones limitadas según permisos definidos."
        }
    }
}

/// Usuario para inicio de sesión
@Model
final class AuthUser {

    /// Nombre de usuario (único)
    var username: String

    /// Hash de la contraseña (por ahora simple; en producción usar CryptoKit)
    var passwordHash: String

    /// Rol almacenado como String para que SwiftData lo persista
    var roleRaw: String

    /// Usuario activo o deshabilitado
    var isActive: Bool

    /// Fecha de creación
    var createdAt: Date

    init(
        username: String,
        passwordHash: String,
        role: AppUserRole,
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.username = username
        self.passwordHash = passwordHash
        self.roleRaw = role.rawValue
        self.isActive = isActive
        self.createdAt = createdAt
    }

    // MARK: - Helpers de rol

    var role: AppUserRole {
        get { AppUserRole(rawValue: roleRaw) ?? .cashier }
        set { roleRaw = newValue.rawValue }
    }
}

// MARK: - Utilidades de contraseña (simple para desarrollo)

extension AuthUser {
    /// Para desarrollo: NO es seguro para producción.
    static func hash(password: String) -> String {
        // Aquí podrías usar CryptoKit (SHA256) si quieres algo mejor,
        // pero por ahora una implementación simple para no complicar.
        return String(password.reversed()) + "|salt"
    }

    func checkPassword(_ password: String) -> Bool {
        return AuthUser.hash(password: password) == passwordHash
    }
}
