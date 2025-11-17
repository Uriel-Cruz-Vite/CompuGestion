//
//  Logger.swift
//  CompuGestion
//
//  Created by Uriel Cruz on 17/11/25.
//
import Foundation

/// Logger simple para depuración. Envuelve print() con formato y categoría.
enum Logger {
    
    /// Log general
    static func log(_ message: String,
                    function: String = #function,
                    file: String = #file,
                    line: Int = #line) {
        
        print("📝 LOG >> \(source(file)): \(function) [L:\(line)] → \(message)")
    }
    
    /// Log de error
    static func error(_ message: String,
                      function: String = #function,
                      file: String = #file,
                      line: Int = #line) {
        
        print("❌ ERROR >> \(source(file)): \(function) [L:\(line)] → \(message)")
    }

    /// Log de éxito
    static func success(_ message: String,
                        function: String = #function,
                        file: String = #file,
                        line: Int = #line) {
        
        print("✅ SUCCESS >> \(source(file)): \(function) [L:\(line)] → \(message)")
    }
    
    /// Log de advertencia
    static func warning(_ message: String,
                        function: String = #function,
                        file: String = #file,
                        line: Int = #line) {
        
        print("⚠️ WARNING >> \(source(file)): \(function) [L:\(line)] → \(message)")
    }
    
    /// Extrae solo el nombre del archivo sin la ruta completa.
    private static func source(_ file: String) -> String {
        file.components(separatedBy: "/").last ?? file
    }
}
