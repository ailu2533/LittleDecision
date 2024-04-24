//
//  DecisionListItem.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/24.
//

import SwiftUI

struct DecisionListItem: View {
    private var text: String
    private var selected: Bool
    

    init(text: String, selected: Bool = false) {
        self.text = text
        self.selected = selected
    }

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
            Text(text)
            Spacer()
        }.contentShape(Rectangle())

        .foregroundStyle(selected ? Color(.systemBlue) : Color(.systemGray))
    }
}

#Preview("测试") {
    List {
        DecisionListItem(text: "五一去哪里玩")
        DecisionListItem(text: "周末去哪里玩")
        DecisionListItem(text: "晚饭吃什么", selected: true)
    }
}
