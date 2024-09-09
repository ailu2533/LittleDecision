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

let emailAddress = "im.ailu@outlook.com"

struct SettingsView: View {
    @Default(.noRepeat) private var noRepeat
    @Default(.equalWeight) private var equalWeight
    @Default(.rotationTime) private var rotationTime
    @Default(.fontSize) private var fontSize
    @Default(.enableSound) private var enableSound

    @Environment(\.openURL) var openURL

    @Environment(SubscriptionViewModel.self)
    private var subscriptionViewModel

    @State private var showPaywall = false

    @State private var isPremium = false

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
//                    .listRowSeparator(.hidden)

                contactSection
//                    .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .settingsBackground()
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPaywall, content: {
                PaywallView(displayCloseButton: true)
            })
        }
    }

    private var settingsSection: some View {
        Section {
            SettingToggle(isOn: $noRepeat, icon: "repeat", foregroundColor: .netureBlack, backgroundColor: .secondaryAccent, title: "不重复抽取", description: "已经被抽中的选项不会被抽中")

            SettingToggle(isOn: $equalWeight, icon: "equal.square", foregroundColor: .netureBlack, backgroundColor: .secondaryAccent, title: "等概率抽取", description: "抽取时忽略选项的权重")

            SettingToggle(isOn: $enableSound, icon: "speaker.wave.3", foregroundColor: .netureBlack, backgroundColor: .secondaryAccent, title: "声音", description: nil)

            rotationTimePicker
        }
    }

    private var contactSection: some View {
        ContactSection()
    }

    private var rotationTimePicker: some View {
        HStack {
            SettingIconView(icon: .system(icon: "stopwatch", foregroundColor: .netureBlack, backgroundColor: .secondaryAccent))

            Picker("转盘旋转时长", selection: $rotationTime) {
                ForEach([2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0], id: \.self) { duration in
                    Text("\(Int(duration))秒").tag(duration)
                }
            }
        }
    }

    private var fontSizeSlider: some View {
        VStack {
            HStack {
                Image(systemName: "textformat.size")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                Text("字体大小")
                Spacer()
                Text("\(Int(fontSize))")
            }

            Slider(value: $fontSize, in: 12 ... 24, step: 1)
                .accentColor(.orange)
        }
    }
}


