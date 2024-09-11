//
//  AddChoiceButton.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import SwiftUI
import LemonViews

struct AddChoiceButton: View {
    let decision: Decision

    var body: some View {
        NavigationLink(destination: ChoiceAddView(decision: decision)) {
            Label("新选项", systemImage: "plus.circle.fill")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.biege)
                .clipShape(Capsule())
                .foregroundStyle(.accent)
                .shadow(radius: 1)
        }
        .buttonStyle(.plain)

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
        let choices = choiceString.split(separator: "\n").map { Choice(content: String($0), weight: 1) }
        decision.choices.append(contentsOf: choices)
    }
}

struct BatchAddChoiceButton: View {
    let decision: Decision

    var body: some View {
        NavigationLink(destination: BatchAddChoiceView(decision: decision)) {
            Label("批量添加", systemImage: "plus.circle.fill")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.biege)
                .clipShape(Capsule())
                .foregroundStyle(.accent)
                .shadow(radius: 1)
        }
        .buttonStyle(.plain)

        .frame(maxWidth: .infinity, alignment: .trailing)
//        .padding()
    }
}
