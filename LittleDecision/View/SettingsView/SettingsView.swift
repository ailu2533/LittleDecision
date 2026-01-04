//
//  SettingsView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import Defaults
import LemonViews
import RevenueCat
import RevenueCatUI
import SwiftUI

// let emailAddress = "im.ailu@outlook.com"

// MARK: - SettingsView

struct SettingsView: View {
    @Default(.noRepeat) private var noRepeat
    @Default(.equalWeight) private var equalWeight
    @Default(.rotationTime) private var rotationTime
//    @Default(.fontSize) private var fontSize
    @Default(.enableSound) private var enableSound

    @Environment(\.openURL) var openURL

    @Environment(SubscriptionViewModel.self)
    private var subscriptionViewModel

    @Environment(GlobalViewModel.self)
    private var globalViewModel

    @State private var showPaywall = false

//    @State private var isPremium = false

    var body: some View {
        NavigationStack {
            Form {
                Button(action: {
                    showPaywall = true
                }, label: {
                    PremiumView(isPremium: subscriptionViewModel.canAccessContent)
                })
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear)
                .listRowInsets(.zero)

                settingsSection

                contactSection
            }
//            .settingsBackground()
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPaywall, content: {
                PaywallView(displayCloseButton: true)
            })
        }
    }

    @ViewBuilder
    private var settingsSection: some View {
        Section {
            Toggle(isOn: $noRepeat) {
                Label {
                    VStack(alignment: .leading) {
                        Text("不重复抽取")
                        Text("已经被抽中的选项不会被抽中")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                } icon: {
                    Image(systemSymbol: .repeat)
                }
            }

            Toggle(isOn: $equalWeight) {
                Label {
                    VStack(alignment: .leading) {
                        Text("等概率抽取")
                        Text("抽取时忽略选项的权重")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                } icon: {
                    Image(systemSymbol: .equalSquare)
                }
            }

            Toggle(isOn: $enableSound) {
                Label {
                    Text("声音")
                } icon: {
                    Image(systemSymbol: .speakerWave3)
                }
            }

            rotationTimePicker
        }.onChange(of: noRepeat) { _, newValue in
            globalViewModel.send(.userDefaultsNoRepeat(newValue))
        }.onChange(of: equalWeight) { _, newValue in
            globalViewModel.send(.userDefaultsEqualWeight(newValue))
        }
        .labelStyle(SettingsLabelStyle(backgroundColor: .cyan))
    }

    private var contactSection: some View {
        ContactSection()
    }

    private var rotationTimePicker: some View {
        Picker(selection: $rotationTime) {
            ForEach([2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0], id: \.self) { duration in
                Text("\(Int(duration))秒").tag(duration)
            }
        } label: {
            Label("转盘旋转时长", systemSymbol: .stopwatch)
        }
    }
}
