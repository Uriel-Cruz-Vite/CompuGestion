//
//  AppFonts.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI

/// Sistema centralizado de tipografías.
/// Permite mantener consistencia y cambiar fuentes fácilmente.
enum AppFonts {

    /// Títulos grandes (por ejemplo, en Dashboard)
    static var largeTitle: Font {
        .system(size: 28, weight: .bold, design: .rounded)
    }

    /// Título de sección o encabezados
    static var sectionTitle: Font {
        .system(size: 20, weight: .semibold, design: .rounded)
    }

    /// Títulos de tarjetas / celdas de listas
    static var cardTitle: Font {
        .system(size: 16, weight: .semibold, design: .rounded)
    }

    /// Texto de acción primaria (botones principalmente)
    static var button: Font {
        .system(size: 15, weight: .medium, design: .rounded)
    }

    /// Cuerpo de texto estándar
    static var body: Font {
        .system(size: 14, weight: .regular, design: .rounded)
    }

    /// Texto secundario (celdas, subtítulos)
    static var caption: Font {
        .system(size: 12, weight: .regular, design: .rounded)
    }

    /// Texto pequeño y atenuado
    static var footnote: Font {
        .system(size: 11, weight: .regular, design: .rounded)
    }
}
