//
//  WeightInfoSection.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import LemonViews
import SwiftUI

struct WeightInfoSection: View {
    let choice: Choice
    @State private var totalWeight: Int = 0

    var body: some View {
        Section {
            HStack {
                SettingIconView(icon: .system(icon: "scalemass.fill", foregroundColor: .netureBlack, backgroundColor: .secondaryAccent))
                LabeledContent("总权重", value: "\(totalWeight)")
            }

            HStack {
                SettingIconView(icon: .system(icon: "percent", foregroundColor: .netureBlack, backgroundColor: .secondaryAccent))
                LabeledContent("当前选项概率", value: probability(choice.weight, totalWeight))
            }
        }
        .task(id: choice.weight) {
            totalWeight = choice.decision?.totalWeight ?? 0
        }
    }
}
