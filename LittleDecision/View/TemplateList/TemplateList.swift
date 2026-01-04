//
//  TemplateList.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/7.
//

import HorizontalPicker
import LemonViews
import SwiftUI

// MARK: - DecisionTemplate

struct DecisionTemplate: Hashable {
    let title: String
    let tags: [TemplateKind]
    let choices: [String]
}

// MARK: - TemplateList

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
            }
            .navigationDestination(for: DecisionTemplate.self) { template in
                DecisionAddView(showSheet: $showSheet, template: template)
                    .navigationBarBackButtonHidden()
            }
            .mainBackground()
            .navigationTitle("选取模板")
            .navigationBarTitleDisplayMode(.inline)
            .task { await loadData() }
        }
    }

    private func loadData() async {
        // 读取 JSON 文件
        guard let url = Bundle.main.url(forResource: getLocalizedTemplateFileName(), withExtension: nil) else {
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

// MARK: - CategoryPicker

struct CategoryPicker: View {
    @Binding var selected: TemplateKind

    var body: some View {
        HorizontalSelectionPicker(
            items: TemplateKind.allCases,
            selectedItem: $selected,
            backgroundColor: Color(.systemBackground),
            verticalPadding: 8
        ) { item in
            Text(item.text)
        }
    }
}

// MARK: - TemplateListView

struct TemplateListView: View {
    let data: DecisionData
    let selected: TemplateKind
    @Binding var path: NavigationPath

    var decisions: [DecisionItem] {
        data.decisions.filter { decision in
            decision.tags.contains(where: { $0 == selected })
        }
    }

    var body: some View {
        LemonList {
            ForEach(decisions) { temp in
                PlaceHolderView(
                    template: DecisionTemplate(title: temp.title, tags: [], choices: temp.choices.map(\.content)),
                    path: $path
                )
            }
        }
    }
}

// MARK: - CustomWheelButton

// struct CustomWheelButton: View {
//    @Binding var path: NavigationPath
//
//    var body: some View {
//        Button(action: {
//            path.append(DecisionTemplate(title: "", tags: [], choices: []))
//        }) {
//            Text("自定义新转盘")
//        }
//        .buttonStyle(FullWidthButtonStyle(verticalPadding: 12))
//        .padding(.horizontal, 16)
//        .padding(.bottom, 16)
//    }
// }

private func getLocalizedTemplateFileName() -> String {
    let locale = Locale.current
    let languageCode = locale.language.languageCode?.identifier ?? "en"

    switch languageCode {
    case "zh": return "frequentUsed.json"
    default: return "frequentUsed.en.json"
    }
}
