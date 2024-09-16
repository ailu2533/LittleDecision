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
    @Binding var title: String
    @FocusState private var focused

    var body: some View {
        HStack {
            SettingIconView(icon: .system(icon: "doc.text", foregroundColor: .primary, backgroundColor: .secondaryAccent))

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
        }
        .onAppearOnce {
            focused = true
        }
    }
}

#Preview {
    ChoiceTitleView(title: .constant("hello world"))
}
