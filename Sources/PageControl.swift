//
//  PageControl.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public protocol PageControlBody: View {
    init(pageCount: Int, theme: PageControlTheme, selectedPage: Int)
}

public struct DefaultPageControlBody: View, PageControlBody {
    public let pageCount: Int
    public let theme: PageControlTheme
    public let selectedPage: Int
    
    public init(pageCount: Int, theme: PageControlTheme, selectedPage: Int) {
        self.pageCount = pageCount
        self.theme = theme
        self.selectedPage = selectedPage
    }
    
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
    
    public struct Horizontal<Body>: View where Body: PageControlBody {
        public let pageCount: Int
        public let theme: PageControlTheme
        public let selectedPage: Int

        public var body: some View {
            HStack(spacing: theme.spacing) {
                Body(pageCount: pageCount, theme: theme, selectedPage: selectedPage)
            }.modifier(Background(theme: theme))
        }
    }

    public struct Vertical<Body>: View where Body: PageControlBody {
        public let pageCount: Int
        public let theme: PageControlTheme
        public let selectedPage: Int

        public var body: some View {
            VStack(spacing: theme.spacing) {
                Body(pageCount: pageCount, theme: theme, selectedPage: selectedPage)
            }.modifier(Background(theme: theme))
        }
    }
    
    typealias DefaultHorizontal = Horizontal<DefaultPageControlBody>
    typealias DefaultVertical = Vertical<DefaultPageControlBody>
}

#if DEBUG
struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        PageControl.DefaultHorizontal(pageCount: 3, theme: .default, selectedPage: 0)
    }
}
#endif
