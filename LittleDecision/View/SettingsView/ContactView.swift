//
//  ContactView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import SwiftUI
import UIKit

func copyToClipboard(_ text: String) {
    UIPasteboard.general.string = text
}

struct ContactView: View {
    let emailAddress = "example@example.com"
    @State private var isCopied = false

    var body: some View {
        VStack {
            Button(action: {
                copyToClipboard(emailAddress)
                isCopied = true

                // 2秒后重置复制状态
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isCopied = false
                }
            }) {
                VStack {
                    Text(isCopied ? "已复制" : "复制邮箱地址")
                    Text("\(emailAddress)")
                }
            }
            .padding()
            .background(isCopied ? Color.green : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    ContactView()
}
