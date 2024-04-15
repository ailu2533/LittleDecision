//
//  CommonPreview.swift
//  MyHabit
//
//  Created by ailu on 2024/3/27.
//

import Foundation
import SwiftUI

@MainActor
struct CommonPreview<Content: View>: View {
    let container = getModelContainer(isStoredInMemoryOnly: false)
    @State private var vm: DecisionViewModel

    var content: Content

    init(content: Content) {
        self.content = content
        let context = container.mainContext
        vm = DecisionViewModel(modelContext: context)
//        vm.addSamples()
//        print(vm.fetchAllTags())
    }

    var body: some View {
        VStack {
            content
        }.environment(vm)
    }
}
