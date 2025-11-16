//
//  WorkOrderStatus.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 16/11/25.
//

import Foundation

/// Estado de una orden de trabajo dentro del taller.
enum WorkOrderStatus: String, CaseIterable, Identifiable, Codable {
    case received      = "received"
    case inDiagnosis   = "in_diagnosis"
    case inRepair      = "in_repair"
    case waitingParts  = "waiting_parts"
    case ready         = "ready"
    case delivered     = "delivered"

    var id: String { rawValue }

    /// Texto amigable para mostrar en la UI.
    var localizedTitle: String {
        switch self {
        case .received:      return "Recibido"
        case .inDiagnosis:   return "En diagnóstico"
        case .inRepair:      return "En reparación"
        case .waitingParts:  return "Esperando refacciones"
        case .ready:         return "Listo para entregar"
        case .delivered:     return "Entregado"
        }
    }
}
