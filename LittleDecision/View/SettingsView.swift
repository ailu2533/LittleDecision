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
                        
                        VStack(alignment:.leading) {
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
                

                
            }.navigationTitle("设置")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
