//
//  ChoiceTitleView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import LemonViews
import SwiftUI
import SwiftUIX

struct ChoiceTitleView: View {
    // MARK: Internal

    @Binding var title: String

    var body: some View {
        TextField("选项名", text: $title, axis: .vertical)
            .lineLimit(3)
            .font(.headline)
            .focused($focused)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(action: { focused = false }) {
                            Label("收起键盘", systemImage: "keyboard.chevron.compact.down")
                        }
                    }
                }
            }
            .onAppearOnce {
                focused = true
            }
    }

    // MARK: Private

    @FocusState private var focused
}

#Preview {
    ChoiceTitleView(title: .constant("hello world"))
}
