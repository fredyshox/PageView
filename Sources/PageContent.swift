//
//  PageContent.swift
//  PageView
//
//  Created by Kacper Raczy on 11/02/2020.
//

import SwiftUI

struct HorizontalPageStack<Pages>: View where Pages: View {
    let pages: Pages
    let geometry: GeometryProxy
    
    init(pages: Pages, geometry: GeometryProxy){
        self.pages = pages
        self.geometry = geometry
    }
    
    var body: some View {
        HStack(spacing: 0.0) {
            pages
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct VerticalPageStack<Pages>: View where Pages: View {
    let pages: Pages
    let geometry: GeometryProxy
    
    init(pages: Pages, geometry: GeometryProxy){
        self.pages = pages
        self.geometry = geometry
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            pages
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct PageContent<Stack, Control>: View where Stack: View, Control: View {
    @ObservedObject var state: PageScrollState
    let compositeView: Stack
    let childCount: Int
    let pageControlBuilder: (Int, Binding<Int>) -> Control
    let axis: Axis
    let alignment: Alignment
    let geometry: GeometryProxy
    private let baseOffset: CGFloat
    
    init(state: PageScrollState, axis: Axis, alignment: Alignment, geometry: GeometryProxy, childCount: Int, compositeView: Stack, pageControlBuilder: @escaping (Int, Binding<Int>) -> Control) {
        self.state = state
        self.compositeView = compositeView
        self.childCount = childCount
        self.pageControlBuilder = pageControlBuilder
        self.geometry = geometry
        self.axis = axis
        self.alignment = alignment
        if axis == .horizontal {
            self.baseOffset = (geometry.size.width / 2) * CGFloat(childCount - 1)
        } else {
            self.baseOffset = (geometry.size.height / 2) * CGFloat(childCount - 1)
        }
    }
    
    var body: some View {
        let pageControl = pageControlBuilder(childCount, $state.selectedPage)
        
        return ZStack(alignment: .center) {
            compositeView
                .offset(offset(using: geometry))
            Rectangle()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .disabled(true)
                .foregroundColor(.clear)
                .overlay(pageControl, alignment: alignment)
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
    
    private func offset(using geometry: GeometryProxy) -> CGSize {
        if axis == .horizontal {
            let value = horizontalOffset(using: geometry)
            return CGSize(width: value, height: 0.0)
        } else {
            let value = verticalOffset(using: geometry)
            return CGSize(width: 0.0, height: value)
        }
    }
    
    private func horizontalOffset(using geometry: GeometryProxy) -> CGFloat {
        if state.isGestureActive {
            return baseOffset + state.contentOffset
        } else {
            return baseOffset + -1 * CGFloat(state.selectedPage) * geometry.size.width
        }
    }
    
    private func verticalOffset(using geometry: GeometryProxy) -> CGFloat {
        if state.isGestureActive {
            return baseOffset + state.contentOffset
        } else {
            return baseOffset + -1 * CGFloat(state.selectedPage) * geometry.size.height
        }
    }
}

//struct PageContent<Pages>: View where Pages: View {
//    @ObservedObject var state: PageScrollState
//    let theme: PageControlTheme
//    let compositeView: Pages
//    let childCount: Int
//    let axis: PageAxis
//    let geometry: GeometryProxy
//    private let baseOffset: CGFloat
//
//    init(state: PageScrollState, theme: PageControlTheme, axis: PageAxis, geometry: GeometryProxy, childCount: Int, compositeView: Pages) {
//        self.state = state
//        self.theme = theme
//        self.compositeView = compositeView
//        self.childCount = childCount
//        self.axis = axis
//        self.geometry = geometry
//        if case .horizontal(_) = axis {
//            self.baseOffset = (geometry.size.width / 2) * CGFloat(childCount - 1)
//        } else {
//            self.baseOffset = (geometry.size.height / 2) * CGFloat(childCount - 1)
//        }
//    }
//
//    var body: some View {
//        let pageControl =
//            PageControl.DefaultHorizontal(pageCount: childCount,
//                                          selectedPage: $state.selectedPage,
//                                          theme: theme)
//                .offset(y: -theme.offset)
//
//        return ZStack(alignment: .center) {
//            HStack(spacing: 0.0) {
//                self.compositeView
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//            }
//                .offset(x: self.horizontalOffset(using: geometry))
//            Rectangle()
//                .frame(width: geometry.size.width, height: geometry.size.height)
//                .disabled(true)
//                .foregroundColor(.clear)
//                .overlay(pageControl, alignment: alignment)
//        }.frame(width: geometry.size.width, height: geometry.size.height)
//    }
//
//    private func horizontal(using geometry: GeometryProxy, alignment: Alignment) -> some View {
//        let pageControl =
//            PageControl.DefaultHorizontal(pageCount: childCount,
//                                          selectedPage: $state.selectedPage,
//                                          theme: theme)
//                .offset(y: -theme.offset)
//
//        return ZStack(alignment: .center) {
//            HStack(spacing: 0.0) {
//                self.compositeView
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//            }
//                .offset(x: self.horizontalOffset(using: geometry))
//            Rectangle()
//                .frame(width: geometry.size.width, height: geometry.size.height)
//                .disabled(true)
//                .foregroundColor(.clear)
//                .overlay(pageControl, alignment: alignment)
//        }.frame(width: geometry.size.width, height: geometry.size.height)
//    }
//
//    private func horizontalOffset(using geometry: GeometryProxy) -> CGFloat {
//        if state.isGestureActive {
//            return baseOffset + state.contentOffset
//        } else {
//            return baseOffset + -1 * CGFloat(state.selectedPage) * geometry.size.width
//        }
//    }
//
//    private func vertical(using geometry: GeometryProxy, alignment: Alignment) -> some View {
//        let pageControl =
//            PageControl.DefaultVertical(pageCount: childCount,
//                                          selectedPage: $state.selectedPage,
//                                          theme: theme)
//                .offset(x: theme.offset)
//
//        return ZStack(alignment: .center) {
//            VStack(spacing: 0.0) {
//                self.compositeView
//                    .frame(width: geometry.size.width, height: geometry.size.height)
//            }
//                .offset(y: self.verticalOffset(using: geometry))
//            Rectangle()
//                .frame(width: geometry.size.width, height: geometry.size.height)
//                .disabled(true)
//                .foregroundColor(.clear)
//                .overlay(pageControl, alignment: alignment)
//        }.frame(width: geometry.size.width, height: geometry.size.height)
//    }
//
//    private func verticalOffset(using geometry: GeometryProxy) -> CGFloat {
//        if state.isGestureActive {
//            return baseOffset + state.contentOffset
//        } else {
//            return baseOffset + -1 * CGFloat(state.selectedPage) * geometry.size.height
//        }
//    }
//}
