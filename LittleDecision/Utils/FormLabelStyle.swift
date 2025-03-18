import LemonViews
import SwiftUI

// MARK: - FormLabelStyle

public struct FormLabelStyle: LabelStyle {
    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundColor(.secondary)
                .font(.footnote)
                .frame(width: 28, height: 28)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            configuration.title
        }
    }
}

// MARK: - IconBackgroundModifier

/// 图标背景修饰器，用于统一设置图标的大小、背景色和圆角等样式
private struct IconBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.secondary)
            .font(.footnote)
            .frame(width: 28, height: 28)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// 为 View 添加便捷方法
extension View {
    /// 添加统一的图标背景样式
    /// - Parameter color: 背景颜色
    func iconBackground() -> some View {
        modifier(IconBackgroundModifier())
    }
}
