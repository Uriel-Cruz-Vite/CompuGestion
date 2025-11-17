//
//  Array+Safe.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//

import Foundation

extension Array {

    /// Acceso seguro: devuelve nil si el índice no existe.
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
