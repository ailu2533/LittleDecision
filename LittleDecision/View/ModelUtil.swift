//
//  ModelUtil.swift
//  MyHabit
//
//  Created by ailu on 2024/3/27.
//

import Foundation
import SwiftData

func getModelContainer(isStoredInMemoryOnly: Bool = true) -> ModelContainer {
    print(URL.applicationSupportDirectory.path(percentEncoded: false))

    return {
        let schema = Schema([
            Choice.self,
            Decision.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }() as ModelContainer
}
