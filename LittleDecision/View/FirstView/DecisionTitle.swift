//
//  DecisionTitle.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import SwiftUI

struct DecisionTitle: View {
    let decision: Decision?
    var currentDecisionTitle: String?

    @State private var showSheet = false

    var body: some View {
        Group {
            if let decision {
                Button(action: {
                    showSheet = true
                    print("hello world")
                }, label: {
                    Text(decision.title)
                        .font(customTitleFont)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                })

            } else {
                Text("没有决定")
                    .font(customTitleFont)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
            }
        }
        .sheet(isPresented: $showSheet, content: {
            if let decision {
                NavigationStack {
                    CommonEditView(decision: decision)
                        .navigationTitle("编辑决定")
                        .navigationBarTitleDisplayMode(.inline)
                }
            } else {
                Text("")
            }
        })
    }
}
