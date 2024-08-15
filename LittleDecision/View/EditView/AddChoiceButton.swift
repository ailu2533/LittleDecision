//
//  AddChoiceButton.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import SwiftUI

struct AddChoiceButton: View {
    let decision: Decision

    var body: some View {
        NavigationLink(destination: ChoiceAddView(decision: decision)) {
            Label("新选项", systemImage: "plus.circle.fill")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color(.systemBackground))
                .clipShape(Capsule())
                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
    }
}
