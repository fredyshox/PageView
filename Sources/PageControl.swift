//
//  PageControl.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public enum PageControl {
    struct Background: ViewModifier {
        let theme: PageControlTheme
        
        func body(content: Content) -> some View {
            content
                .padding(theme.padding)
                .background(backgroundRect())
        }
        
        private func backgroundRect() -> some View {
            let radius = theme.dotSize / 2 + theme.padding
            return RoundedRectangle(cornerRadius: radius)
                .foregroundColor(theme.backgroundColor)
        }
    }
    
    public struct Horizontal<Body>: View where Body: View {
        public typealias PageControlBody = (Int, Int, PageControlTheme) -> Body
        
        public let pageCount: Int
        public let selectedPage: Int
        public let theme: PageControlTheme
        public let bodyCreator: PageControlBody

        public var body: some View {
            HStack(spacing: theme.spacing) {
                bodyCreator(pageCount, selectedPage, theme)
            }.modifier(Background(theme: theme))
        }
    }

    public struct Vertical<Body>: View where Body: View {
        public typealias PageControlBody = (Int, Int, PageControlTheme) -> Body
        
        public let pageCount: Int
        public let selectedPage: Int
        public let theme: PageControlTheme
        public let bodyCreator: PageControlBody

        public var body: some View {
            VStack(spacing: theme.spacing) {
                bodyCreator(pageCount, selectedPage, theme)
            }.modifier(Background(theme: theme))
        }
    }
    
    // MARK: Default implementation
    
    public struct DefaultPageControlBody: View {
        public let pageCount: Int
        public let selectedPage: Int
        public let theme: PageControlTheme
        
        public var body: some View {
            ForEach(0..<pageCount) { (i) in
                 Circle()
                     .frame(width: self.theme.dotSize, height: self.theme.dotSize)
                     .foregroundColor(self.dotColor(index: i))
             }
        }
        
        private func dotColor(index: Int) -> Color {
            if index == selectedPage {
                return theme.dotActiveColor
            } else {
                return theme.dotInactiveColor
            }
        }
    }
    
    public static func DefaultHorizontal(pageCount: Int, selectedPage: Int, theme: PageControlTheme) -> Horizontal<DefaultPageControlBody> {
        return Horizontal(pageCount: pageCount, selectedPage: selectedPage, theme: theme) {
            DefaultPageControlBody(pageCount: $0, selectedPage: $1, theme: $2)
        }
    }
    
    public static func DefaultVertical(pageCount: Int, selectedPage: Int, theme: PageControlTheme) -> Vertical<DefaultPageControlBody> {
        return Vertical(pageCount: pageCount, selectedPage: selectedPage, theme: theme) {
            DefaultPageControlBody(pageCount: $0, selectedPage: $1, theme: $2)
        }
    }
}

#if DEBUG
struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        PageControl.DefaultHorizontal(pageCount: 3, selectedPage: 0, theme: .default)
    }
}
#endif
