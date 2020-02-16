//
//  PageContent.swift
//  PageView
//
//  Created by Kacper Raczy on 11/02/2020.
//

import SwiftUI

struct PageContent: View {
    @ObservedObject var state: PageScrollState
    let theme: PageControlTheme
    let views: [AnyView]
    let axis: Axis
    let geometry: GeometryProxy
    
    var body: some View {
        if axis == .horizontal {
            return AnyView(horizontal(using: geometry))
        } else {
            return AnyView(vertical(using: geometry))
        }
    }
    
    private func horizontal(using geometry: GeometryProxy) -> some View {
        let alignment = Alignment(horizontal: .center, vertical: .bottom)
        return
            ZStack(alignment: alignment) {
                HStack(spacing: 0.0) {
                    ForEach(0..<self.views.count) { (i) in
                        self.views[i]
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                    .offset(x: self.horizontalOffset(using: geometry, alignment: .center))
                PageControl.DefaultHorizontal(pageCount: self.views.count, selectedPage: self.$state.selectedPage, theme: self.theme)
                    .offset(y: -self.theme.offset)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
    }
    
    private func horizontalOffset(using geometry: GeometryProxy, alignment: HorizontalAlignment) -> CGFloat {
        // currently for center only
        let baseValue = (geometry.size.width / 2) * CGFloat(views.count - 1)
        if state.isGestureActive {
            return baseValue + state.contentOffset
        } else {
            return baseValue + -1 * CGFloat(state.selectedPage) * geometry.size.width
        }
    }
    
    private func vertical(using geometry: GeometryProxy) -> some View {
        let alignment = Alignment(horizontal: .leading, vertical: .center)
        return
            ZStack(alignment: alignment) {
                VStack(spacing: 0.0) {
                    ForEach(0..<self.views.count) { (i) in
                        self.views[i]
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                    .offset(y: self.verticalOffset(using: geometry, alignment: .center))
                PageControl.DefaultVertical(pageCount: self.views.count, selectedPage: self.$state.selectedPage, theme: self.theme)
                    .offset(x: self.theme.offset)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
    }
    
    private func verticalOffset(using geometry: GeometryProxy, alignment: VerticalAlignment) -> CGFloat {
        // currently center only
        let baseValue = (geometry.size.height / 2) * CGFloat(views.count - 1)
        if state.isGestureActive {
            return baseValue + state.contentOffset
        } else {
            return baseValue + -1 * CGFloat(state.selectedPage) * geometry.size.height
        }
    }
}
