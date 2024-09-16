//
//  ChoiceWeightView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import LemonViews
import SwiftUI

struct ChoiceWeightView: View {
    @Binding var weight: Int

    var body: some View {
        HStack {
            SettingIconView(icon: .system(icon: "scalemass", foregroundColor: .primary, backgroundColor: .secondaryAccent))
            Picker("权重", selection: $weight) {
                ForEach(1 ... 100, id: \.self) { Text("\($0)") }
            }
        }
    }
}

#Preview {
    ChoiceWeightView(weight: .constant(10))
}
