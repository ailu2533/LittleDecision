//
//  SpinWheelPreview.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation
import SwiftUI

struct SpinWheelPreview: View {
    var skinKind: SkinKind

    private var configuration: SpinWheelConfiguration {
        SkinManager.shared.getSkinConfiguration(skinKind: skinKind)
    }

    var body: some View {
        GeometryReader { proxy in

            let width = min(proxy.size.width, proxy.size.height)
            let size = CGSize(width: width, height: width)

            HStack {
                Spacer()
                SpinWheel(rawItems: rawItems,
                          size: size,
                          configuration: configuration
                )
                .frame(width: width, height: width, alignment: .center)
                Spacer()
            }
        }
    }
}

#Preview {
    VStack {
        SpinWheelPreview(skinKind: .blue)
        SpinWheelPreview(skinKind: .blueWhite)
        SpinWheelPreview(skinKind: .pinkWhite)
        SpinWheelPreview(skinKind: .pinkBlue)
            .preferredColorScheme(.dark)
    }
}
