//
//  AddChoiceButton.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import LemonViews
import SwiftUI

struct AddChoiceButton: View {
    let decision: Decision

    var body: some View {
        NavigationLink(destination: ChoiceAddView(decision: decision)) {
            Label("新选项", systemImage: "plus.circle.fill")
        }
        .buttonStyle(FloatingButtonStyle())
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct AddChoiceButton2: View {
    let decision: TemporaryDecision

    var body: some View {
        NavigationLink(destination: ChoiceAddView2(decision: decision)) {
            Label("新选项", systemImage: "plus.circle.fill")
        }
        .buttonStyle(FloatingButtonStyle())
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct BatchAddChoiceView: View {
    @State private var choices: String = ""
    let decision: Decision

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            TextEditor(text: $choices)

            Button(action: {
                batchAddChoices(choiceString: choices)
                dismiss()
            }, label: {
                Text("完成")
            })
        }
    }

    private func batchAddChoices(choiceString: String) {
        let choices = choiceString.split(separator: "\n").map {
            Choice(content: String($0), weight: 1)
        }
        decision.choices?.append(contentsOf: choices)
    }
}
