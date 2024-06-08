//
//  ChoiceAddView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI

struct ChoiceAddView: View {
   
    @Environment(\.modelContext)
    private var modelContext

    @State private var decision: Decision = Decision(title: "", choices: [])

    init() {
    }

    var body: some View {
        NavigationStack {
            CommonEditView(decision: decision)
        }.onAppear {
            modelContext.insert(decision)
        }
    }
}

#Preview {
    ChoiceAddView()
}

