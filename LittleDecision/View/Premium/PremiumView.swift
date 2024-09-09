//
//  PremiumButton.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import SwiftUI

struct PremiumView: View {
    var isPremium: Bool

    var body: some View {
        HStack {
            Spacer()
            Image(isPremium ? .smile : .cry)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            Spacer()
            VStack(spacing: 12) {
                Text(isPremium ? "您是高贵的会员" : "您还不是会员")
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundColor(.netureWhite)
                if isPremium {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                            .font(.headline)
                            .padding(.leading)

                        Text("终身会员")
                            .fontWeight(.semibold)
                            .font(.headline)
                            .foregroundColor(.netureWhite)
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                    }
                    .background(.orange)
                    .clipShape(Capsule())

                } else {
                    Text("支持一下")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundColor(.netureWhite)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.orange)
                        .clipShape(Capsule())
                }
            }
            Spacer()
        }
        .padding(.vertical, 12)
        .background(LinearGradient(colors: [.accent.opacity(0.8), .accent.opacity(0.6), .accent.opacity(0.4)], startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(6)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.accent.opacity(0.7), .accent.opacity(0.1)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

        VStack {
            PremiumView(isPremium: false)
                .padding(16)
            PremiumView(isPremium: true)
                .padding(16)
            Spacer()
        }
    }
}