//
//  Theme.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public struct PageControlTheme {
    public var backgroundColor: Color
    public var dotActiveColor: Color
    public var dotInactiveColor: Color
    public var dotSize: CGFloat
    public var spacing: CGFloat
    public var padding: CGFloat
    public var xOffset: CGFloat
    public var yOffset: CGFloat
    public var alignment: Alignment?
    
    public init(
        backgroundColor: Color,
        dotActiveColor: Color,
        dotInactiveColor: Color,
        dotSize: CGFloat,
        spacing: CGFloat,
        padding: CGFloat,
        xOffset: CGFloat,
        yOffset: CGFloat,
        alignment: Alignment? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.dotActiveColor = dotActiveColor
        self.dotInactiveColor = dotInactiveColor
        self.dotSize = dotSize
        self.spacing = spacing
        self.padding = padding
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.alignment = alignment
    }
    
    public static var `default`: PageControlTheme {
        #if os(iOS)
            return PageControlTheme(
                backgroundColor: .black,
                dotActiveColor: .white,
                dotInactiveColor: Color(white: 1.0, opacity: 0.2),
                dotSize: 7.0,
                spacing: 9.0,
                padding: 4.0,
                xOffset: 12.0,
                yOffset: -12.0,
                alignment: nil
            )
        #elseif os(watchOS)
            return PageControlTheme(
                backgroundColor: .black,
                dotActiveColor: .white,
                dotInactiveColor: Color(white: 1.0, opacity: 0.2),
                dotSize: 6.0,
                spacing: 5.0,
                padding: 2.0,
                xOffset: 0.0,
                yOffset: 0.0,
                alignment: nil
            )
        #else
            return PageControlTheme(
                backgroundColor: .black,
                dotActiveColor: .white,
                dotInactiveColor: Color(white: 1.0, opacity: 0.2),
                dotSize: 12.0,
                spacing: 8.0,
                padding: 8.0,
                xOffset: 16.0,
                yOffset: -16.0,
                alignment: nil
            )
        #endif
    }
}
