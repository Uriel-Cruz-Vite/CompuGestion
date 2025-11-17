//
//  AppIcons.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import SwiftUI

/// Sistema centralizado de íconos.
/// Permite unificar el estilo visual y cambiar íconos desde un solo lugar.
enum AppIcons {

    // MARK: - Secciones principales
    static let dashboard = "rectangle.grid.2x2"
    static let workOrders = "wrench.and.screwdriver"
    static let customers = "person.3"
    static let inventory = "shippingbox"
    static let settings = "gearshape"

    // MARK: - Estados de órdenes
    static let statusReceived = "doc.badge.arrow.down"
    static let statusInDiagnosis = "stethoscope"
    static let statusInRepair = "gearshape.2"
    static let statusWaitingParts = "hourglass"
    static let statusReady = "checkmark.circle"
    static let statusDelivered = "mailbox"

    // MARK: - Acciones generales
    static let add = "plus"
    static let edit = "pencil"
    static let delete = "trash"
    static let save = "checkmark"
    static let cancel = "xmark"
    static let filter = "line.3.horizontal.decrease.circle"
    static let search = "magnifyingglass"
    static let pdf = "doc.richtext"
    static let export = "square.and.arrow.up"
    static let print = "printer"

    // MARK: - Elementos UI
    static let empty = "questionmark.circle"
    static let warning = "exclamationmark.triangle"
    static let error = "xmark.octagon"
    static let info = "info.circle"
}
