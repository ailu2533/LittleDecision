//
//  ChoiceRow.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/14.
//

import SwiftUI

/// 表示单个选项的视图。
struct ChoiceRow: View {
    @Bindable var choice: Choice
    @Binding var tappedChoiceUUID: UUID?
//    @FocusState private var focusedField: Field?
    @Environment(DecisionViewModel.self) private var vm
    var decision: Decision
    @Binding var totalWeight: Int

    enum Field: Hashable {
        case title, weight
    }

    var body: some View {
        editModeView
    }

    private var editModeView: some View {
        HStack {
            Image(systemName: "tag")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(.green)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text("")

            TextField("选项名", text: $choice.title)
                .padding(.trailing, 90)

                .overlay(alignment: .trailing) {
                    Text(probability())
                        .monospaced()
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.accentColor.opacity(0.3))
                        .clipShape(Capsule())
                }
        }
//        .listRowSeparator(.hidden)
    }

    private var displayModeView: some View {
        HStack {
            Text(choice.title)
                .lineLimit(1)
            Spacer()
            Text(probability())
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

    private func probability() -> String {
        let result = Double(choice.weight) / Double(totalWeight) * 100
        return String(format: "%.1f%%", result)
    }
}
