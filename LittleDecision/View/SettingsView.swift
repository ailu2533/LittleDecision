//
//  SettingsView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import SwiftUI

struct CarouselSettingsView: View {
    @AppStorage("noRepeat") private var noRepeat = false
    @AppStorage("equalWeight") private var equalWeight = false
    @AppStorage("rotationTime") private var rotationTime = 4

    var body: some View {
        NavigationStack {
            Form {
                Toggle(isOn: $noRepeat, label: {
                    Text("不重复抽取")
                })
                
                

                Toggle(isOn: $equalWeight, label: {
                    Text("隐藏权重")
                })

                Picker(selection: $rotationTime) {
                    ForEach([2, 3, 4, 5, 6, 7, 8], id: \.self) {
                        Text("\($0)秒")
                            .tag($0)
                    }
                } label: {
                    Text("旋转时长")
                }
            }.navigationTitle("设置")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
