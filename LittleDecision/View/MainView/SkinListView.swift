//
//  SkinListView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import Defaults
import RevenueCatUI
import SpinWheel
import SwiftUI

// MARK: - SkinListView

struct SkinListView: View {
    // MARK: Internal

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(SkinKind.allCases) { skinKind in
                        Button(action: {
                            let configuration = SkinManager.shared.getSkinConfiguration(skinKind: skinKind)

                            if configuration.isPremium, !subscriptionViewModel.canAccessContent {
                                showPaywall = true
                                return
                            }

                            if selectedSkinConfiguration != skinKind {
                                selectedSkinConfiguration = skinKind
                                dismiss()
                            }
                        }, label: {
                            SkinPreviewItem(skinKind: skinKind)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: selectedSkinConfiguration)
            .sheet(isPresented: $showPaywall, content: {
                PaywallView(displayCloseButton: true)
            })
            .background(Color(uiColor: UIColor.systemGroupedBackground))
            .mainBackground()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("关闭")
                    })
                }
            }
        }
    }

    // MARK: Private

    @Environment(\.dismiss)
    private var dismiss

    @Default(.selectedSkinConfiguration) private var selectedSkinConfiguration

    @Environment(SubscriptionViewModel.self)
    private var subscriptionViewModel

    @State private var showPaywall = false
}

// MARK: - SkinPreviewItem

struct SkinPreviewItem: View {
    // MARK: Internal

    let skinKind: SkinKind

    var isPremium: Bool {
        SkinManager.shared.getSkinConfiguration(skinKind: skinKind).isPremium
    }

    var body: some View {
        HStack {
            Spacer()
            SpinWheelPreview(skinKind: skinKind)
                .frame(width: 250, height: 250, alignment: .center)
                .padding()
                .background(Material.thick)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .border(cornerRadius: 25, stroke: .init(selectedSkinConfiguration == skinKind ? .green : .clear, lineWidth: 2))
                .shadow(radius: 1)
                .overlay(alignment: .bottomTrailing) {
                    if isPremium {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                            .font(.headline)
                            .padding(16)
                    }
                }

            Spacer()
        }
    }

    // MARK: Private

    @Default(.selectedSkinConfiguration) private var selectedSkinConfiguration
}
