//
//  KeyboardAccessoryView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import SwiftUI

struct KeyboardAccessoryView: View {
    @Environment(\.softwareKeyboard) private var softwareKeyboard

    @Binding var text: String
    @Binding var weight: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack {
                LabeledContent {
                    Text("总权重")
                } label: {
                    Text("总权重")
                }
                LabeledContent {
                    Text("99%")
                } label: {
                    Text("概率")
                }

                LabeledContent {
                    TextField("选项名", text: $text)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("选项名")
                }

                LabeledContent {
                    TextField("权重", value: $weight, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)

                } label: {
                    Text("权重")
                }
            }

            HStack {
                Spacer()
                HStack(spacing: 24) {
                    Button(action: {}, label: {
                        Text("继续新增")
                    })

                    Button(action: {}, label: {
                        Text("完成")
                    })
                }
            }
        }
        .padding(16)
        .background(Color.biege)
        .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 12, topTrailing: 12)))
        .opacity(softwareKeyboard?.isVisible == true ? 1 : 0)
    }
}

#Preview {
    KeyboardAccessoryView(text: .constant(""), weight: .constant(1))
}
