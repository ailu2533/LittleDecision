//
//  PlaceHolderView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/11.
//

import SwiftUI

struct PlaceHolderView: View {
    var template: DecisionTemplate = DecisionTemplate(title: "情侣真心话大冒险", tags: [], choices: ["1", "2", "3"])
    @Binding var path: NavigationPath

    var body: some View {
        Button {
            path.append(template)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(template.title)
                        .font(.headline)
                    Text("\(template.choices.count)个选项")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()

                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }

        }
        .tint(.primary)
    }
}
