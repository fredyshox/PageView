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
    public var offset: CGFloat
    public var alignment: Alignment?
    
    public static var `default`: PageControlTheme {
        #if os(iOS)
            return PageControlTheme(
                backgroundColor: .black,
                dotActiveColor: .white,
                dotInactiveColor: Color(white: 1.0, opacity: 0.2),
                dotSize: 7.0,
                spacing: 9.0,
                padding: 4.0,
                offset: 12.0,
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
                offset: 0.0,
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
                offset: 16.0,
                alignment: nil
            )
        #endif
    }
}
