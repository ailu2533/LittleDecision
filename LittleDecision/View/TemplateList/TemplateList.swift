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
    let choices: [String]
}

struct PlaceHolderView: View {
    var template: DecisionTemplate = DecisionTemplate(title: "情侣真心话大冒险", choices: ["1", "2", "3"])
    @Binding var path: NavigationPath

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(template.title)
                    .font(.headline)
                Text("\(template.choices.count)个选项")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            Button(action: {
                path.append(template)
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}

let kPickerId = UUID()

struct TemplateList: View {
    @State private var selected = "热门"

    @State private var path = NavigationPath()

    @Binding var showSheet: Bool

    @State private var data = DecisionData(decisions: [])

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HorizontalSelectionPicker(pickerId: kPickerId,
                                          items: ["热门", "恋爱", "答案之书", "真心话", "大冒险", "学校生活"],
                                          selectedItem: $selected,
                                          backgroundColor: .white.opacity(0.8),
                                          verticalPadding: 8) { item in
                    Text(item)
                }

                List {
                    ForEach(data.decisions.indices, id: \.self) { index in
                        let temp = data.decisions[index]
                        PlaceHolderView(
                            template: DecisionTemplate(title: temp.title, choices: temp.choices.map({ item in
                                item.content
                            })),
                            path: $path)
                            .listRowSeparator(.hidden)
                    }
                }
                .contentMargins(.vertical, 2)
                .scrollContentBackground(.hidden)
                .padding(.bottom, 16)

                Button(action: {
                    path.append(DecisionTemplate(title: "", choices: []))
                }, label: {
                    Text("自定义新转盘")
                })
                .buttonStyle(FullWidthButtonStyle(verticalPadding: 12))
                .padding(.horizontal, 16)
            }
            .navigationDestination(for: DecisionTemplate.self) { template in
                DecisionAddView(showSheet: $showSheet, template: template)
            }
            .mainBackground()

            .navigationTitle("选取模板")
            .navigationBarTitleDisplayMode(.inline)
            .task {
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
    }
}

#Preview {
    TemplateList(showSheet: .constant(true))
}
