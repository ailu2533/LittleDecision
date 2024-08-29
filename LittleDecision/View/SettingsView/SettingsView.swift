//
//  SettingsView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import Defaults
import LemonViews
import SwiftUI

struct SettingsView: View {
    @Default(.noRepeat) private var noRepeat
    @Default(.equalWeight) private var equalWeight
    @Default(.rotationTime) private var rotationTime
    @Default(.fontSize) private var fontSize
    @Default(.enableSound) private var enableSound
    
    @Environment(\.openURL) var openURL


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

            settingToggle(title: "声音",
                          description: nil,
                          icon: "speaker.wave.3",
                          isOn: $enableSound)

//            fontSizeSlider
        }
    }

    private var contactSection: some View {
        Section("联系我们") {
            contactButton(title: "小红书", icon: "person.2", urlString: "xhsdiscover://user/60ba522d0000000001008b88")
            contactButton(title: "问题反馈", icon: "envelope", urlString: "https://docs.qq.com/sheet/DWllUVmZwS21sd1Zw?tab=BB08J2")
            contactButton(title: "给我们好评", icon: "hand.thumbsup", urlString: "itms-apps://itunes.apple.com/app/id6504145207?action=write-review")

            ShareLink(item: URL(string: "https://apps.apple.com/cn/app/%E6%9F%9A%E5%AD%90%E5%B0%8F%E5%86%B3%E5%AE%9A-%E6%B2%BB%E6%84%88%E4%BD%A0%E7%9A%84%E9%80%89%E6%8B%A9%E5%9B%B0%E9%9A%BE%E7%97%87/id6504145207")!) {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button("Contact Developer") {
                let subject = "Support email from app user"
                let email = SupportEmail(toAddress: "im.ailu@outlook.com", subject: subject)
                email.send(openURL: openURL)
            }
        }
    }

    private func settingToggle(title: LocalizedStringKey, description: LocalizedStringKey?, icon: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Toggle(isOn: isOn) {
                VStack(alignment: .leading) {
                    Text(title)
                    if let description {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var rotationTimePicker: some View {
        HStack {
            Image(systemName: "stopwatch")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

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

    private func contactButton(title: LocalizedStringKey, icon: String, urlString: String) -> some View {
        SettingsOpenUrlButton(title: title, icon: icon, iconBackground: .orange, urlString: urlString)
    }
}
