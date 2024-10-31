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
        MainViewDecisionTitle(decision: globalViewModel.selectedDecision)
        MainViewChoiceTitleView(selectedChoice: globalViewModel.selectedChoice)
    }
}
