//
//  CommonEditView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI
import TipKit

struct ChoiceTip: Tip {
    var image: Image? {
        Image(systemName: "lightbulb")
    }

    var title: Text {
        Text("编辑选项")
    }

    var message: Text? {
        Text("**点击选项**可以编辑选项名和权重\n被选中概率=权重/总权重\n**向左滑动**删除选项")
    }
}

/// 主视图，用于编辑决策和其选项。
struct CommonEditView: View {
    @Bindable var decision: Decision // 绑定的决策对象

    @Environment(\.dismiss) private var dismiss // 环境变量，用于视图的关闭操作

    @Environment(DecisionViewModel.self) private var vm // 视图模型，用于数据处理

    @Environment(\.modelContext) private var modelContext // 数据模型上下文环境

    @State private var tappedChoiceUUID: UUID? // 当前被选中的选项的 UUID

    @State private var totalWeight = 0 // 所有选项的总权重

    private let tip = ChoiceTip()

    var body: some View {
        Form {
            Section("决定名") {
                TextField("决定名", text: $decision.title)
                    .font(.title3)
                    .submitLabel(.done)
            }

            Section {
                List {
                    ForEach(decision.sortedChoices) { choice in
                        ChoiceRow(choice: choice, tappedChoiceUUID: $tappedChoiceUUID, decision: decision, totalWeight: $totalWeight)
                    }
                    .onDelete { indexSet in
                        vm.deleteChoices(from: decision, at: indexSet)
                        totalWeight = decision.totalWeight
                    }
                    if !decision.choices.isEmpty {
                        TipView(tip, arrowEdge: .top)
                            .tipBackground(Color.clear)
                            .listRowBackground(Color.accentColor.opacity(0.1))
                            .listSectionSpacing(0)
                            .listRowSpacing(0)
                    }
                }
            } header: {
                HStack {
                    Text("选项列表")
                    Spacer()
                    Text("总权重 \(totalWeight)")
                }
            }
            
            
            

            Section {
                Button("新增选项") {
                    addNewChoice()
                }
            }
        }
        .onAppear {
            totalWeight = decision.totalWeight
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    /// 添加新选项的方法。
    private func addNewChoice() {
        let newChoice = vm.addNewChoice(to: decision)
        tappedChoiceUUID = newChoice.uuid
        totalWeight += 1
    }
}

/// 表示单个选项的视图。
struct ChoiceRow: View {
    @Bindable var choice: Choice // 绑定的选项对象
    @Binding var tappedChoiceUUID: UUID? // 绑定的被选中选项的 UUID
    @FocusState private var focusedField: Field? // 当前焦点所在的字段

    @Environment(\.modelContext) private var modelContext // 数据模型上下文环境

    @Environment(DecisionViewModel.self) private var vm // 视图模型

    var decision: Decision // 当前的决策对象

    @Binding var totalWeight: Int // 绑定的总权重

    enum Field {
        case title, weight
    }

    /// 添加新选项并更新权重的方法。
    private func addNewChoice() {
        let newChoice = vm.addNewChoice(to: decision)
        tappedChoiceUUID = newChoice.uuid
        totalWeight += 1
    }

    var body: some View {
        HStack {
            if tappedChoiceUUID == choice.uuid {
                VStack {
                    TextField("选项名", text: $choice.title)
                        .focused($focusedField, equals: .title)
                        .onAppear {
                            DispatchQueue.main.async {
                                self.focusedField = .title
                            }
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .weight
                        }

                    TextField("权重", value: $choice.weight, formatter: NumberFormatter())
                        .focused($focusedField, equals: .weight)
                        .keyboardType(.numberPad)
                        .toolbar {
                            if focusedField == .weight || focusedField == .title {
                                ToolbarItemGroup(placement: .keyboard) {
                                    switch focusedField {
                                    case .title:
                                        Text("选项名不能为空")
                                    case .weight:
                                        Text("权重需要大于0")
                                    case nil:
                                        EmptyView()
                                    }

                                    Spacer() // 使文本居中
                                    Button("继续新增") {
                                        addNewChoice()
                                        totalWeight += choice.weight - 1
                                    }.disabled(choice.title.isEmpty)
                                    Button("完成") {
                                        focusedField = nil // 关闭键盘
                                        tappedChoiceUUID = nil
                                        if choice.title.isEmpty {
                                            vm.deleteChoice(from: decision, choice: choice)
                                        }
                                        totalWeight = decision.totalWeight
                                    }
                                }
                            }
                        }

                        .onChange(of: choice.weight, { _, newValue in
                            if newValue <= 0 {
                                choice.weight = 1
                            }
                        })

                        .onSubmit {
                            focusedField = nil
                        }
                }

            } else {
                HStack {
                    Text(choice.title)
                    Spacer()
//                    Text("\(choice.weight)")

                    Text("\(probability())%")
                        .monospaced()
                        .frame(width: 64, alignment: .trailing)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.accent.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                }.contentShape(Rectangle())
                    .onTapGesture {
                        tappedChoiceUUID = choice.uuid
                    }
            }
        }
    }

    /// 计算并返回选项的概率，结果最多保留两位小数，尾数为0则不显示。
    func probability() -> String {
        let result = Double(choice.weight) / Double(totalWeight) * 100

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0 // 最小小数位数为0，尾数0不显示

        return formatter.string(from: NSNumber(value: result)) ?? "0"
    }
}
