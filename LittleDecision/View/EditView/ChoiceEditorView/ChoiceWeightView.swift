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
        Picker(selection: $weight) {
            ForEach(1 ... 100, id: \.self) { Text(verbatim: "\($0)") }
        } label: {
            Text("权重")
        }
    }
}

#Preview {
    ChoiceWeightView(weight: .constant(10))
}
