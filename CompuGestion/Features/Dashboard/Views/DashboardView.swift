//
//  DashboardView.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//
import SwiftUI
import SwiftData

struct DashboardView: View {
    // Órdenes de trabajo (todas)
    @Query(sort: \WorkOrder.createdAt, order: .reverse)
    private var workOrders: [WorkOrder]

    // Facturas (si no estás usando aún Invoice, puedes comentar este @Query)
    @Query(sort: \Invoice.issueDate, order: .reverse)
    private var invoices: [Invoice]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Resumen general")
                    .font(.largeTitle)
                    .bold()

                Text("Vista rápida del estado de tu taller de cómputo.")
                    .foregroundStyle(.secondary)

                // MARK: - Tarjetas de métricas
                HStack(alignment: .top, spacing: 16) {
                    StatsCardView(
                        title: "Órdenes abiertas",
                        value: "\(openOrdersCount)",
                        subtitle: "En diagnóstico, reparación o esperando refacciones",
                        systemImage: "wrench.and.screwdriver"
                    )

                    StatsCardView(
                        title: "Órdenes de hoy",
                        value: "\(todayOrdersCount)",
                        subtitle: "Registradas en la fecha actual",
                        systemImage: "calendar"
                    )

                    StatsCardView(
                        title: "Ingresos estimados",
                        value: formattedCurrency(estimatedRevenue),
                        subtitle: "Suma de costos estimados (no facturas reales)",
                        systemImage: "pesosign.circle"
                    )
                }

                Divider()
                    .padding(.vertical, 8)

                // MARK: - Sección de detalle simple
                VStack(alignment: .leading, spacing: 8) {
                    Text("Últimas órdenes")
                        .font(.title2)
                        .bold()

                    if workOrders.isEmpty {
                        Text("Aún no tienes órdenes registradas.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(workOrders.prefix(5)) { order in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(order.customerName)
                                        .font(.headline)

                                    Text(order.deviceDescription)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(order.status.localizedTitle)
                                    .font(.caption)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 6)
                                    .background(Color.secondary.opacity(0.1))
                                    .cornerRadius(6)
                            }
                            .padding(.vertical, 4)

                            Divider()
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }

    // MARK: - Métricas calculadas

    private var openOrdersCount: Int {
        workOrders.filter { $0.status != .delivered }.count
    }

    private var todayOrdersCount: Int {
        let calendar = Calendar.current
        return workOrders.filter { calendar.isDateInToday($0.createdAt) }.count
    }

    /// Ingreso estimado: suma de `estimatedCost` en órdenes abiertas
    private var estimatedRevenue: Double {
        workOrders
            .filter { $0.status != .delivered }
            .map { $0.estimatedCost }
            .reduce(0, +)
    }

    // Si quisieras usar invoices reales más adelante:
    /*
    private var totalInvoiced: Double {
        invoices.map { $0.total }.reduce(0, +)
    }
    */

    // MARK: - Helpers

    private func formattedCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "MXN"
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

// MARK: - Subvista interna para tarjetas de stats

private struct StatsCardView: View {
    let title: String
    let value: String
    let subtitle: String?
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: systemImage)
                    .font(.title2)
                Text(title)
                    .font(.headline)
            }

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))

            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(radius: 1, y: 1)
        )
    }
}
