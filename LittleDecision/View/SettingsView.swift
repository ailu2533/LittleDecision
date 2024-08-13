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
                Section {
                    HStack {
                        Image(systemName: "repeat")
                            .font(.system(size: 24))
                            .foregroundColor(.accentColor)
                            .frame(width: 30)

                        Toggle(isOn: $noRepeat, label: {
                            VStack(alignment: .leading) {
                                Text("不重复抽取")
                                Text("已经被抽中的选项不会被抽中")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                //                            .padding(.leading, 12)
                            }

                        })
                    }

                    HStack {
                        Image(systemName: "equal.square")
                            .font(.system(size: 24))
                            .foregroundColor(.accentColor)
                            .frame(width: 30)

                        Toggle(isOn: $equalWeight, label: {
                            VStack(alignment: .leading) {
                                Text("等概率抽取")
                                Text("抽取时忽略选项的权重")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                        })
                    }

                    HStack {
                        Image(systemName: "stopwatch")
                            .font(.system(size: 24))
                            .foregroundColor(.accentColor)
                            .frame(width: 30)

                        Picker(selection: $rotationTime) {
                            ForEach([2, 3, 4, 5, 6, 7, 8], id: \.self) {
                                Text("\($0)秒")
                                    .tag($0)
                            }
                        } label: {
                            Text("转盘旋转时长")
                        }
                    }
                }

                Section("联系我们") {
                    HStack {
                        Image(systemName: "person.2")
                        Button("小红书") {
                            if let url = URL(string: "xhsdiscover://user/60ba522d0000000001008b88") {
                                openURL(url)
                            }
                        }
                    }

//                    HStack {
//                        Image(systemName: "hand.thumbsup")
//                        Button("给我们好评") {
//                            if let url = URL(string: "itms-apps://itunes.apple.com/app/id6499009310?action=write-review") {
//                                openURL(url)
//                            }
//                        }
//                    }

                    HStack {
                        Image(systemName: "envelope")
                        Button("问题反馈") {
                            if let url = URL(string: "https://docs.qq.com/sheet/DWllUVmZwS21sd1Zw?tab=BB08J2") {
                                openURL(url)
                            }
                        }
                    }
                }

            }.navigationTitle("设置")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
