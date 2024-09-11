//
//  TemplateList.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/7.
//

import HorizontalPicker
import LemonViews
import SwiftUI

struct DecisionTemplate: Hashable {
    let title: String
    let tags: [TemplateKind]
    let choices: [String]
}

let kPickerId = UUID()

struct TemplateList: View {
    @State private var selected = TemplateKind.hot
    @State private var path = NavigationPath()
    @Binding var showSheet: Bool
    @State private var data = DecisionData(decisions: [])

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                CategoryPicker(selected: $selected)
                TemplateListView(data: data, selected: selected, path: $path)
                CustomWheelButton(path: $path)
            }
            .navigationDestination(for: DecisionTemplate.self) { template in
                DecisionAddView(showSheet: $showSheet, template: template)
            }
            .mainBackground()
            .navigationTitle("选取模板")
            .navigationBarTitleDisplayMode(.inline)
            .task { await loadData() }
        }
    }
    
    private func loadData() async {
        // 读取 JSON 文件
        guard let url = Bundle.main.url(forResource: "frequentUsed.json", withExtension: nil) else {
            Logging.shared.error("url empty")
            return
        }

        do {
            let content = try Data(contentsOf: url)
            data = try JSONDecoder().decode(DecisionData.self, from: content)
        } catch {
            Logging.shared.error("\(error)")
            return
        }
    }
}

struct CategoryPicker: View {
    @Binding var selected: TemplateKind
    
    var body: some View {
        HorizontalSelectionPicker(pickerId: kPickerId,
                                  items: TemplateKind.allCases,
                                  selectedItem: $selected,
                                  backgroundColor: .buttonBackground,
                                  verticalPadding: 8) { item in
            Text(item.text)
        }
    }
}

struct TemplateListView: View {
    let data: DecisionData
    let selected: TemplateKind
    @Binding var path: NavigationPath
    
    var body: some View {
        LemonList {
            ForEach(data.decisions.indices, id: \.self) { index in
                let temp = data.decisions[index]
                if temp.tags.contains(where: { $0 == selected }) {
                    PlaceHolderView(
                        template: DecisionTemplate(title: temp.title, tags: [], choices: temp.choices.map { $0.content }),
                        path: $path
                    )
                }
            }
        }
        .padding(.bottom, 16)
    }
}

struct CustomWheelButton: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        Button(action: {
            path.append(DecisionTemplate(title: "", tags: [], choices: []))
        }) {
            Text("自定义新转盘")
        }
        .buttonStyle(FullWidthButtonStyle(verticalPadding: 12))
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

#Preview {
    TemplateList(showSheet: .constant(true))
}
