//
//  Money.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//
import Foundation

/// Representa un valor monetario con precisión decimal segura.
/// Ideal para evitar problemas con Double en cálculos financieros.
struct Money: Hashable, Codable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    
    private let value: Decimal
    
    // Moneda fija MXN (puedes cambiarlo luego si deseas multi-moneda)
    static let currencyCode = "MXN"
    
    // MARK: - Inicializadores
    
    init(decimal: Decimal) {
        self.value = decimal
    }
    
    init(floatLiteral value: Double) {
        self.value = Decimal(value)
    }
    
    init(integerLiteral value: Int) {
        self.value = Decimal(value)
    }
    
    init(_ double: Double) {
        self.value = Decimal(double)
    }
    
    // MARK: - Acceso interno
    
    var decimalValue: Decimal { value }
    var doubleValue: Double { NSDecimalNumber(decimal: value).doubleValue }
    
    // MARK: - Formato
    
    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Money.currencyCode
        return formatter.string(from: value as NSDecimalNumber) ?? "$0.00"
    }
    
    // MARK: - Operaciones
    
    static func + (lhs: Money, rhs: Money) -> Money {
        Money(decimal: lhs.value + rhs.value)
    }
    
    static func - (lhs: Money, rhs: Money) -> Money {
        Money(decimal: lhs.value - rhs.value)
    }
    
    static func * (lhs: Money, rhs: Decimal) -> Money {
        Money(decimal: lhs.value * rhs)
    }
    
    static func * (lhs: Money, rhs: Double) -> Money {
        Money(decimal: lhs.value * Decimal(rhs))
    }
    
    static func > (lhs: Money, rhs: Money) -> Bool {
        lhs.value > rhs.value
    }
    
    static func < (lhs: Money, rhs: Money) -> Bool {
        lhs.value < rhs.value
    }
}
