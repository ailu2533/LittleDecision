//
//  ChoiceDetailsSection.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import LemonViews
import SwiftUI

struct ChoiceDetailsSection: View {
    @Bindable var choice: Choice
    @FocusState var focused: Bool

    var body: some View {
        Section {
            ChoiceTitleView(title: $choice.title)
            ChoiceWeightView(weight: $choice.weight)
        }
    }
}
