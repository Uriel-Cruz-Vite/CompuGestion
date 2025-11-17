//
//  NumberFormater+Extensions.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation

extension NumberFormatter {

    /// Crea un formatter de moneda en MXN listo para usar
    static var currencyMXN: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "MXN"
        formatter.locale = Locale(identifier: "es_MX")
        return formatter
    }

    /// Crea un formatter de números sin decimales
    static var integer: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }

    /// Crea un formatter “compacto” (1.2K, 3.5M, etc.)
    static var compact: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 2
        formatter.maximumSignificantDigits = 3
        return formatter
    }
}
