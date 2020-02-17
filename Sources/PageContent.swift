//
//  PageContent.swift
//  PageView
//
//  Created by Kacper Raczy on 11/02/2020.
//

import SwiftUI

public enum PageAxis {
    case horizontal(alignment: Alignment)
    case vertical(alignment: Alignment)
    
    public static var horizontal: PageAxis {
        return horizontal(alignment: Alignment(horizontal: .center, vertical: .bottom))
    }
    
    public static var vertical: PageAxis {
        return vertical(alignment: Alignment(horizontal: .leading, vertical: .center))
    }
}

struct PageContent<Page>: View where Page: View {
    @ObservedObject var state: PageScrollState
    let theme: PageControlTheme
    let views: [Page]
    let axis: PageAxis
    let geometry: GeometryProxy
    private let baseOffset: CGFloat
    
    init(state: PageScrollState, theme: PageControlTheme, views: [Page], axis: PageAxis, geometry: GeometryProxy) {
        self.state = state
        self.theme = theme
        self.views = views
        self.axis = axis
        self.geometry = geometry
        if case .horizontal(_) = axis {
            self.baseOffset = (geometry.size.width / 2) * CGFloat(views.count - 1)
        } else {
            self.baseOffset = (geometry.size.height / 2) * CGFloat(views.count - 1)
        }
    }
    
    var body: some View {
        switch axis {
        case .horizontal(alignment: let alignment):
            return AnyView(horizontal(using: geometry, alignment: alignment))
        case .vertical(alignment: let alignment):
            return AnyView(vertical(using: geometry, alignment: alignment))
        }
    }
    
    private func horizontal(using geometry: GeometryProxy, alignment: Alignment) -> some View {
        let pageControl =
            PageControl.DefaultHorizontal(pageCount: self.views.count,
                                          selectedPage: self.$state.selectedPage,
                                          theme: self.theme)
                .offset(y: -self.theme.offset)

        return ZStack(alignment: .center) {
            HStack(spacing: 0.0) {
                ForEach(0..<self.views.count) { (i) in
                    self.views[i]
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
                .offset(x: self.horizontalOffset(using: geometry))
            Rectangle()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .disabled(true)
                .foregroundColor(.clear)
                .overlay(pageControl, alignment: alignment)
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
    
    private func horizontalOffset(using geometry: GeometryProxy) -> CGFloat {
        if state.isGestureActive {
            return baseOffset + state.contentOffset
        } else {
            return baseOffset + -1 * CGFloat(state.selectedPage) * geometry.size.width
        }
    }
    
    private func vertical(using geometry: GeometryProxy, alignment: Alignment) -> some View {
        let pageControl =
            PageControl.DefaultVertical(pageCount: self.views.count,
                                          selectedPage: self.$state.selectedPage,
                                          theme: self.theme)
                .offset(x: self.theme.offset)

        return ZStack(alignment: .center) {
            VStack(spacing: 0.0) {
                ForEach(0..<self.views.count) { (i) in
                    self.views[i]
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
                .offset(y: self.verticalOffset(using: geometry))
            Rectangle()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .disabled(true)
                .foregroundColor(.clear)
                .overlay(pageControl, alignment: alignment)
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
    
    private func verticalOffset(using geometry: GeometryProxy) -> CGFloat {
        if state.isGestureActive {
            return baseOffset + state.contentOffset
        } else {
            return baseOffset + -1 * CGFloat(state.selectedPage) * geometry.size.height
        }
    }
}
