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

struct SafeAreaInsetsKey: PreferenceKey {
    static var defaultValue = EdgeInsets()
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}

extension View {
    func getSafeAreaInsets(_ safeInsets: Binding<EdgeInsets>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
            }
            .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                safeInsets.wrappedValue = value
            }
        )
    }
}

extension View {
    func printSafeAreaInsets(id: String) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
            }
            .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                print("\(id) insets:\(value)")
            }
        )
    }
}

struct GetSafeArea: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello world")
                    .printSafeAreaInsets(id: "Text")
            }
        }
        .printSafeAreaInsets(id: "NavigationView")
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// iPhone 13 pro
// NavigationView insets:EdgeInsets(top: 47.0, leading: 0.0, bottom: 34.0, trailing: 0.0)
// Text insets:EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)

/// 主视图，用于编辑决策和其选项。
struct CommonEditView: View {
    @Bindable var decision: Decision
    @Environment(DecisionViewModel.self) private var vm
    @Environment(\.modelContext) private var modelContext
    @State private var tappedChoiceUUID: UUID?
    @State private var totalWeight = 0
    private let tip = ChoiceTip()

    @State private var visibility = Visibility.visible

    var body: some View {
        List {
            decisionTitleSection
            choicesSection
        }
        .listStyle(.inset)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(action: {
                    let newChoice = vm.addNewChoice(to: decision)
                    tappedChoiceUUID = newChoice.uuid
                    totalWeight += 1
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("新选项")
                    }
                })
            }
        }
    }

    private var decisionTitleSection: some View {
        HStack {
            Image(systemName: "arrow.triangle.branch")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            TextField("输入让你犹豫不决的事情", text: $decision.title)
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .submitLabel(.done)
        }
        .listRowSeparator(.hidden)
    }

    private var choicesSection: some View {
        Section {
            ForEach(decision.sortedChoices) { choice in
                ChoiceRow(choice: choice, tappedChoiceUUID: $tappedChoiceUUID, decision: decision, totalWeight: $totalWeight)
            }
            .onDelete(perform: deleteChoices)

            if !decision.choices.isEmpty {
                tipView
            }
        } header: {
            HStack {
                Text("选项列表")
                Spacer()
                Text("总权重 \(totalWeight)")
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

    private var addChoiceSection: some View {
        Button("新增选项") {
            let newChoice = vm.addNewChoice(to: decision)
            tappedChoiceUUID = newChoice.uuid
            totalWeight += 1
        }
        .buttonStyle(BorderedButtonStyle())
        .listRowSeparator(.hidden)
    }

    private func deleteChoices(at indexSet: IndexSet) {
        vm.deleteChoices(from: decision, at: indexSet)
        totalWeight = decision.totalWeight
    }
}
