//
//  SelectionIcon.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import Defaults
import SwiftUI

struct SelectionIcon: View {
    @Environment(\.dismiss) private var dismiss

    let decision: Decision
    @Default(.decisionId) private var decisionId

    var body: some View {
        Button(action: {
            decisionId = decision.uuid
            dismiss()
        }, label: {
            Image(systemName: decisionId == decision.uuid ? "checkmark.circle.fill" : "circle")
                .imageScale(.large)
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)
        })
        .buttonStyle(PlainButtonStyle())
    }
}
