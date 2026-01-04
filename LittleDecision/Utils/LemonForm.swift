//
//  LemonForm.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI

struct LemonList<Content: View>: View {
    @ViewBuilder
    let content: () -> Content

    var body: some View {
        List {
            content()
        }
        .contentMargins(.vertical, 16)
        .scrollContentBackground(.hidden)
    }
}
