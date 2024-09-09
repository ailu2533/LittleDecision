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
    @Bindable var decision: Decision
    @Environment(DecisionViewModel.self) private var viewModel
    @FocusState private var focus

    private let tip = ChoiceTip()

    var body: some View {
        Form {
            decisionTitleSection

            Picker("显示模式", selection: Binding(
                get: { DecisionDisplayMode(rawValue: decision.displayModel) ?? .wheel },
                set: { decision.displayModel = $0.rawValue }
            )) {
                ForEach(DecisionDisplayMode.allCases, id: \.self) { mode in
                    Text(mode.text).tag(mode)
                }
            }

            choicesSection
        }
        .contentMargins(16, for: .scrollContent)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                AddChoiceButton(decision: decision)
                BatchAddChoiceButton(decision: decision)
            }
        }
        .ignoresSafeArea(.keyboard)
        .scrollContentBackground(.hidden)
        .mainBackground()
    }

    private var decisionTitleSection: some View {
        HStack {
            Image(systemName: "arrow.triangle.branch")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            TextField("输入让你犹豫不决的事情", text: $decision.title, axis: .vertical)
                .focused($focus)
                .foregroundStyle(.netureBlack)
                .font(.title3)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
//                .submitLabel(.done)
                .lineLimit(3)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack {
                            Spacer()

                            Button(action: {
                                focus = false
                            }, label: {
                                Label("收起键盘", systemImage: "keyboard.chevron.compact.down")
                                    .labelStyle(.iconOnly)
                            })
                        }
                    }
                }
        }
    }

    private var choicesSection: some View {
        Section {
            ForEach(decision.sortedChoices) { choice in
                NavigationLink {
                    ChoiceEditorView(choice: choice, totalWeight: 0)
                } label: {
                    ChoiceRow(choice: choice, totalWeight: 0)
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteChoices)

            if !decision.choices.isEmpty {
                tipView
            }
        }
    }

    private var tipView: some View {
        TipView(tip, arrowEdge: .top)
            .tipBackground(Color.clear)
            .listRowBackground(Color.accentColor.opacity(0.1))
            .listSectionSpacing(0)
            .listRowSpacing(0)
    }

    private func deleteChoices(at indexSet: IndexSet) {
        viewModel.deleteChoices(from: decision, at: indexSet)
    }
}
