//
//  TouchPointsRepresentable.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI


struct TouchPointsRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> TouchPointsView {
        return TouchPointsView()
    }

    func updateUIView(_ uiView: TouchPointsView, context: Context) {
    }

    typealias UIViewType = TouchPointsView
}
