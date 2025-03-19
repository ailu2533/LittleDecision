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
        TextField("输入让你犹豫不决的事情", text: $title)
            .fontWeight(.semibold)
            .focused($focus)
            .submitLabel(.done)
            .onAppearOnce {
                if title.isEmpty {
                    focus = true
                }
            }
    }
}
