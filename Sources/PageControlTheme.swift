//
//  Theme.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public struct PageControlTheme {
    public let backgroundColor: Color
    public let dotActiveColor: Color
    public let dotInactiveColor: Color
    public let dotSize: CGFloat
    public let spacing: CGFloat
    public let padding: CGFloat
    public let offset: CGFloat
    
    public static var `default`: PageControlTheme {
        #if os(iOS)
            return PageControlTheme(
                backgroundColor: .black,
                dotActiveColor: .white,
                dotInactiveColor: Color(white: 1.0, opacity: 0.2),
                dotSize: 7.0,
                spacing: 9.0,
                padding: 4.0,
                offset: 12.0
            )
        #elseif os(watchOS)
            return PageControlTheme(
                backgroundColor: .black,
                dotActiveColor: .white,
                dotInactiveColor: Color(white: 1.0, opacity: 0.2),
                dotSize: 6.0,
                spacing: 5.0,
                padding: 2.0,
                offset: 0.0
            )
        #else
            return PageControlTheme(
                backgroundColor: .black,
                dotActiveColor: .white,
                dotInactiveColor: Color(white: 1.0, opacity: 0.2),
                dotSize: 12.0,
                spacing: 8.0,
                padding: 8.0,
                offset: 16.0
            )
        #endif
    }
}
