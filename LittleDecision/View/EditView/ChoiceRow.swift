//
//  ChoiceRow.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/14.
//

import SwiftUI

enum Field: Hashable {
    case title(UUID)
    case weight(UUID)
}

/// 表示单个选项的视图。
struct ChoiceRow: View {
    @Bindable var choice: Choice
    @Binding var tappedChoiceUUID: UUID?

    @Environment(DecisionViewModel.self) private var vm
    var decision: Decision
    var totalWeight: Int {
        return choice.decision?.totalWeight ?? 0
    }

    var body: some View {
        editModeView
    }

    private var editModeView: some View {
        HStack {
            Image(systemName: "tag")
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .frame(width: 30, height: 30)
//                .background(.green)
//                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            HStack {
                Text(choice.title)

                Spacer()

                Text(probability(choice.weight, totalWeight))
                    .monospaced()
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
//                    .background(Color.systemYellow)
//                    .clipShape(Capsule())
            }
        }
    }

    private var displayModeView: some View {
        HStack {
            Text(choice.title)
                .lineLimit(1)
            Spacer()
            Text(probability(choice.weight, totalWeight))
                .monospaced()
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.accentColor.opacity(0.3))
                .clipShape(Capsule())
        }
        .contentShape(Rectangle())
        .onTapGesture { tappedChoiceUUID = choice.uuid }
        .padding(.vertical, 8)
    }

//    @ToolbarContentBuilder
//    private var keyboardToolbar: some ToolbarContent {
//        ToolbarItemGroup(placement: .keyboard) {
//            if focusedField != nil {
//                Text(focusedField == .title ? "选项名不能为空" : "权重需要大于0")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                Spacer()
//                Button("继续新增") {
//                    let newChoice = vm.addNewChoice(to: decision)
//                    tappedChoiceUUID = newChoice.uuid
//                    totalWeight += choice.weight - 1
//                }
//                .disabled(choice.title.isEmpty)
//                Button("完成") {
//                    finishEditing()
//                }
//            }
//        }
//    }

//    private func finishEditing() {
//        focusedField = nil
//        tappedChoiceUUID = nil
//        if choice.title.isEmpty {
//            vm.deleteChoice(from: decision, choice: choice)
//        }
//        totalWeight = decision.totalWeight
//    }

//    private func probability() -> String {
//        let result = Double(choice.weight) / Double(totalWeight) * 100
//        return String(format: "%.1f%%", result)
//    }
}
