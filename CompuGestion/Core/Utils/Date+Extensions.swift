//
//  Date+Extensions.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation

extension Date {

    /// Devuelve solo la fecha sin hora (00:00)
    var strippedTime: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Retorna true si la fecha es el mismo día que otra
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    /// Retorna una fecha formateada con estilo corto local
    func formattedShort() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// Retorna fecha y hora con estilo corto
    func formattedShortDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// Retorna una fecha amigable (ej: “hoy”, “ayer”, “hace 3 días”)
    func relativeDescription() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
