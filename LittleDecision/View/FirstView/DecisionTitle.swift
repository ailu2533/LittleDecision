//
//  DecisionTitle.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import SwiftUI

struct DecisionTitle: View {
    // MARK: Internal

    let decision: Decision?
    var currentDecisionTitle: String?

    var body: some View {
        Group {
            if let decision {
                Button(action: {
                    showSheet = true
                }, label: {
                    Label(
                        title: {
                            Text(decision.title)
                                .font(customTitleFont)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)

                        },
                        icon: { Image(systemName: "pencil.and.outline").fontWeight(.bold) }
                    )
                    .labelStyle(.titleAndIcon)
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
                Text(verbatim: "")
            }
        })
    }

    // MARK: Private

    @State private var showSheet = false
}
