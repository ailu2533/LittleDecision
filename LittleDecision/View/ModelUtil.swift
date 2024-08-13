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

// protocol Reorderable {
//    var sortValue: Int { get set }
// }
//
// func reorder(habits: [Reorderable], fromOffsets: IndexSet, toOffset: Int) {
//    var sortValueList = [Int]()
//    habits.forEach {
//        sortValueList.append($0.sortValue)
//    }
//
//    var copy = habits
//    copy.move(fromOffsets: fromOffsets, toOffset: toOffset)
//
//    for i in copy.indices {
//        copy[i].sortValue = sortValueList[i]
//    }
// }
