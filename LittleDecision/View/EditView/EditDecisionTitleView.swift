//
//  EditDecisionTitleView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import LemonViews
import SwiftUI
import SwiftUIX

struct EditDecisionTitleView: View {
    @FocusState private var focus
    @Binding var title: String

    var body: some View {
        HStack {
            SettingIconView(
                icon: .system(
                    icon: .arrowTriangleBranch,
                    foregroundColor: .systemBackground,
                    backgroundColor: .accent
                )
            )

            TextField("输入让你犹豫不决的事情", text: $title, axis: .vertical)
                .focused($focus)
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
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
        .onAppearOnce {
            if title.isEmpty {
                focus = true
            }
        }
    }
}

#Preview {
    EditDecisionTitleView(title: .constant("hello"))
}
