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
                .frame(height: 64)
                .padding(.horizontal, 32)

            Text(globalViewModel.choiceTitle)
                .multilineTextAlignment(.center)
                .truncationMode(.middle)
                .fontWeight(.bold)
                .frame(height: 64)
        }
    }
}
