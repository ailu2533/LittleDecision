//
//  LemonForm.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI

struct LemonForm<Content: View>: View {
    @ViewBuilder
    let content: () -> Content

    var body: some View {
        Form {
            content()
        }
        .scrollContentBackground(.hidden)
        .contentMargins(.vertical, 2)
    }
}

struct LemonList<Content: View>: View {
    @ViewBuilder
    let content: () -> Content

    var body: some View {
        List {
            content()
        }
        .contentMargins(.vertical, 2)
        .scrollContentBackground(.hidden)
    }
}
