//
//  AuthService.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 07/12/25.
//

import Foundation
import SwiftData

/// Errores posibles al autenticar
enum AuthError: LocalizedError {
    case userNotFound
    case invalidPassword
    case userDisabled

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Usuario no encontrado."
        case .invalidPassword:
            return "La contraseña es incorrecta."
        case .userDisabled:
            return "Este usuario está deshabilitado."
        }
    }
}

/// Servicio de autenticación y gestión de usuarios
final class AuthService {

    static let shared = AuthService()

    private init() {}

    // MARK: - Seed inicial

    /// Crea un usuario administrador por defecto si no existe ningún usuario.
    ///
    /// Úsalo al inicio de la app (por ejemplo en `RootSceneView.onAppear`).
    func seedInitialAdminIfNeeded(in context: ModelContext) throws {
        let descriptor = FetchDescriptor<AuthUser>()
        let users = try context.fetch(descriptor)

        guard users.isEmpty else { return }

        // Usuario admin por defecto (cámbialo cuando quieras)
        let defaultUsername = "admin"
        let defaultPassword = "admin"

        let admin = AuthUser(
            username: defaultUsername,
            passwordHash: AuthUser.hash(password: defaultPassword),
            role: .admin,
            isActive: true
        )

        context.insert(admin)
        try context.save()

        Logger.success("Usuario admin inicial creado (usuario: \(defaultUsername), contraseña: \(defaultPassword))")
    }

    // MARK: - Login

    /// Intenta iniciar sesión con usuario y contraseña.
    ///
    /// - Returns: El `AuthUser` autenticado si todo es correcto.
    func login(
        username: String,
        password: String,
        in context: ModelContext
    ) throws -> AuthUser {
        let descriptor = FetchDescriptor<AuthUser>(
            predicate: #Predicate { $0.username == username }
        )

        guard let user = try context.fetch(descriptor).first else {
            throw AuthError.userNotFound
        }

        guard user.isActive else {
            throw AuthError.userDisabled
        }

        guard user.checkPassword(password) else {
            throw AuthError.invalidPassword
        }

        return user
    }

    // MARK: - Gestión de usuarios (básico)

    /// Crea un nuevo usuario con rol especificado.
    func createUser(
        username: String,
        password: String,
        role: AppUserRole,
        isActive: Bool = true,
        in context: ModelContext
    ) throws -> AuthUser {
        let descriptor = FetchDescriptor<AuthUser>(
            predicate: #Predicate { $0.username == username }
        )

        if let _ = try context.fetch(descriptor).first {
            throw NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Ya existe un usuario con ese nombre."]
            )
        }

        let user = AuthUser(
            username: username,
            passwordHash: AuthUser.hash(password: password),
            role: role,
            isActive: isActive
        )

        context.insert(user)
        try context.save()

        return user
    }

    /// Cambia la contraseña de un usuario.
    func changePassword(
        for user: AuthUser,
        newPassword: String,
        in context: ModelContext
    ) throws {
        user.passwordHash = AuthUser.hash(password: newPassword)
        try context.save()
    }

    /// Activa / desactiva un usuario.
    func setActive(
        _ isActive: Bool,
        for user: AuthUser,
        in context: ModelContext
    ) throws {
        user.isActive = isActive
        try context.save()
    }
}
