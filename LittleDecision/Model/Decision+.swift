//
//  Decision+.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import Foundation

extension Decision {
    func save() {
        if let modelContext {
            do {
                try modelContext.save()
            } catch {
                Logging.shared.error("\(error)")
            }
        }
    }
}
