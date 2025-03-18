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
            Link(destination: URL(string: xhsLink)!) {
                Label("小红书", systemSymbol: .person2Fill)
            }

            Link(destination: URL(string: problem)!) {
                Label("问题反馈", systemSymbol: .exclamationmarkCircleFill)
            }

            Link(destination: URL(string: problem)!) {
                Label("给我们提建议", systemSymbol: .envelopeFill)
            }

            Link(destination: URL(string: reviewLink)!) {
                Label("给我们好评", systemSymbol: .heartFill)
            }

            ShareLink(item: URL(string: shareLink)!) {
                Label("分享App给好友", systemSymbol: .squareAndArrowUpFill)
            }
//
        }
        .tint(.primary)
        .labelStyle(SettingsLabelStyle(backgroundColor: .yellow))
    }
}

#Preview {
    Form {
        ContactSection()
    }
}
