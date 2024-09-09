//
//  ContactSection.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import LemonViews
import SwiftUI

struct ContactSection: View {
    let xhsLink = "xhsdiscover://user/60ba522d0000000001008b88"
    let problem = "https://txc.qq.com/products/668459"
    let reviewLink = "itms-apps://itunes.apple.com/app/id6504145207?action=write-review"

    let shareLink = "https://apps.apple.com/cn/app/%E6%9F%9A%E5%AD%90%E5%B0%8F%E5%86%B3%E5%AE%9A-%E6%B2%BB%E6%84%88%E4%BD%A0%E7%9A%84%E9%80%89%E6%8B%A9%E5%9B%B0%E9%9A%BE%E7%97%87/id6504145207"

    var body: some View {
        Section("联系我们") {
            SettingsOpenUrlButton(title: "小红书", icon: "person.2.fill", foregroundColor: .red, backgroundColor: .secondaryAccent, urlString: xhsLink)

            SettingsOpenUrlButton(title: "问题反馈", icon: "exclamationmark.circle.fill", foregroundColor: .green, backgroundColor: .secondaryAccent, urlString: problem)

            SettingsOpenUrlButton(title: "给我们提建议", icon: "envelope.fill", foregroundColor: .green, backgroundColor: .secondaryAccent, urlString: problem)

            SettingsOpenUrlButton(title: "给我们好评", icon: "heart.fill", foregroundColor: .red, backgroundColor: .secondaryAccent, urlString: reviewLink)

            if let shareLinkUrl = URL(string: shareLink) {
                ShareLink(item: shareLinkUrl) {
                    HStack {
                        SettingIconView(icon: .system(icon: "square.and.arrow.up.fill", foregroundColor: .blue, backgroundColor: .secondaryAccent))

                        Text("分享App给好友")

                        Spacer()
                        SettingIconView(icon: .system(icon: "arrowshape.turn.up.right.fill", foregroundColor: .gray, backgroundColor: .clear))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }

            EmailButton(title: "邮箱", foregroundColor: .magenta, backgroundColor: .secondaryAccent)
        }
    }
}

#Preview {
    Form {
        ContactSection()
    }
}
