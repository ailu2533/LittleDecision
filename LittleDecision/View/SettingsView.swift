//
//  SettingsView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("noRepeat") private var noRepeat = false
    @AppStorage("equalWeight") private var equalWeight = false
    @AppStorage("rotationTime") private var rotationTime = 4
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            Form {
                settingsSection
                contactSection
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var settingsSection: some View {
        Section {
            settingToggle(title: "不重复抽取",
                          description: "已经被抽中的选项不会被抽中",
                          icon: "repeat",
                          isOn: $noRepeat)

            settingToggle(title: "等概率抽取",
                          description: "抽取时忽略选项的权重",
                          icon: "equal.square",
                          isOn: $equalWeight)

            rotationTimePicker
        }
    }

    private var contactSection: some View {
        Section("联系我们") {
            contactButton(title: "小红书", icon: "person.2", urlString: "xhsdiscover://user/60ba522d0000000001008b88")
            contactButton(title: "问题反馈", icon: "envelope", urlString: "https://docs.qq.com/sheet/DWllUVmZwS21sd1Zw?tab=BB08J2")
        }
    }

    private func settingToggle(title: String, description: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(width: 30)

            Toggle(isOn: isOn) {
                VStack(alignment: .leading) {
                    Text(title)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var rotationTimePicker: some View {
        HStack {
            Image(systemName: "stopwatch")
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(width: 30)

            Picker("转盘旋转时长", selection: $rotationTime) {
                ForEach([2, 3, 4, 5, 6, 7, 8], id: \.self) { duration in
                    Text("\(duration)秒").tag(duration)
                }
            }
        }
    }

    private func contactButton(title: String, icon: String, urlString: String) -> some View {
        HStack {
            Image(systemName: icon)
            Button(title) {
                if let url = URL(string: urlString) {
                    openURL(url)
                }
            }
        }
    }
}
