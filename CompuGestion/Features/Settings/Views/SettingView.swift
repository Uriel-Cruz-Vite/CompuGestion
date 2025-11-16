//
//  SettingView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var businessName: String = "Mi taller de cómputo"
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var taxId: String = ""   // RFC u otro identificador fiscal

    var body: some View {
        Form {
            Section("Datos del negocio") {
                TextField("Nombre del negocio", text: $businessName)
                TextField("Dirección", text: $address)
                TextField("Teléfono", text: $phone)
                TextField("Correo electrónico", text: $email)
                TextField("RFC / Identificador fiscal", text: $taxId)
            }

            Section("Preferencias") {
                Toggle("Mostrar precios con IVA incluido", isOn: .constant(true))
                Toggle("Habilitar notificaciones internas", isOn: .constant(false))
            }

            Section("Acerca de") {
                HStack {
                    Text("Versión de la app")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Desarrollado por")
                    Spacer()
                    Text("Tu nombre / empresa")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .navigationTitle("Configuración")
        .frame(minWidth: 500, minHeight: 400)
    }
}
