//
//  MainViewDecisionTitleAndChoiceTitleView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import SwiftUI

struct MainViewDecisionAndChoiceTitleView: View {
    var globalViewModel: GlobalViewModel

    var body: some View {
        VStack {
            MainViewDecisionTitle(decision: globalViewModel.selectedDecision)
                .frame(height: 48)
                .padding(.horizontal, 32)

            Text(choiceTitle)
                .multilineTextAlignment(.center)
                .truncationMode(.middle)
                .fontWeight(.bold)
                .frame(height: 48)
        }
    }

    var choiceTitle: String {
        globalViewModel.selectedChoice?.content ?? ""
    }
}
