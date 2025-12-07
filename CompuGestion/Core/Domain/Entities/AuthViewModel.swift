//
//  AuthViewModel.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 07/12/25.
//

import Foundation
import Observation
import SwiftData

/// ViewModel de autenticación: maneja login, logout y el usuario actual.
@Observable
class AuthViewModel {

    // Campos del formulario de login
    var username: String = ""
    var password: String = ""

    // Estado
    var isLoading: Bool = false
    var errorMessage: String?
    var currentUser: AuthUser?

    // Servicio de autenticación
    private let authService = AuthService.shared

    // MARK: - Computados útiles

    var isLoggedIn: Bool {
        currentUser != nil
    }

    var currentRole: AppUserRole? {
        currentUser?.role
    }

    var isAdmin: Bool {
        currentUser?.role == .admin
    }

    var isCashier: Bool {
        currentUser?.role == .cashier
    }

    // MARK: - Inicialización / Seed

    /// Carga inicial: crea admin por defecto si no hay usuarios.
    func initialize(in context: ModelContext) {
        do {
            try authService.seedInitialAdminIfNeeded(in: context)
        } catch {
            Logger.error("Error al hacer seed del admin inicial: \(error.localizedDescription)")
        }
    }

    // MARK: - Login / Logout

    func login(in context: ModelContext) {
        errorMessage = nil
        isLoading = true

        let trimmedUser = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPass = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedUser.isEmpty, !trimmedPass.isEmpty else {
            errorMessage = "Ingresa usuario y contraseña."
            isLoading = false
            return
        }

        do {
            let user = try authService.login(
                username: trimmedUser,
                password: trimmedPass,
                in: context
            )
            currentUser = user
            Logger.success("Inicio de sesión correcto como \(user.username) [\(user.role.localizedName)]")
        } catch let authError as AuthError {
            errorMessage = authError.localizedDescription
        } catch {
            errorMessage = "Ocurrió un error al iniciar sesión."
            Logger.error("Error inesperado al hacer login: \(error.localizedDescription)")
        }

        isLoading = false
    }

    func logout() {
        currentUser = nil
        username = ""
        password = ""
        errorMessage = nil
    }
}
