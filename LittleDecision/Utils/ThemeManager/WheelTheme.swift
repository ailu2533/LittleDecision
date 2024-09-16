//
//  WheelTheme.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation
import SwiftUI

struct WheelTheme: Identifiable {
    let id: ThemeID
    let sectorFillStyles: [SectionFill]
    let pointerView: any View
    let outerColor: Color
}
