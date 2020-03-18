//
//  PageView.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public struct HPageView<Pages>: View where Pages: View {
    let state: PageScrollState
    public let theme: PageControlTheme
    public let pages: Pages
    public let pageCount: Int
    
    public init(theme: PageControlTheme = .default, pageCount: Int, @ViewBuilder builder: () -> Pages) {
        self.state = PageScrollState()
        self.theme = theme
        self.pages = builder()
        self.pageCount = pageCount
    }
    
    public var body: some View {
        let pageControlBuilder = { (childCount, selectedPageBinding) in
            return PageControl.DefaultHorizontal(pageCount: childCount,
                                                 selectedPage: selectedPageBinding,
                                                 theme: self.theme)
        }
        
        return GeometryReader { geometry in
            PageContent(state: self.state,
                        axis: .horizontal,
                        alignment: Alignment(horizontal: .center, vertical: .bottom),
                        geometry: geometry,
                        childCount: self.pageCount,
                        compositeView: HorizontalPageStack(pages: self.pages, geometry: geometry),
                        pageControlBuilder: pageControlBuilder)
                .contentShape(Rectangle())
                   .gesture(DragGesture(minimumDistance: 8.0)
                       .onChanged({ self.onDragChanged($0, geometry: geometry) })
                       .onEnded({ self.onDragEnded($0, geometry: geometry) })
                   )
        }
    }
    
    private func onDragChanged(_ value: DragGesture.Value, geometry: GeometryProxy) {
        state.horizontalDragChanged(value, viewCount: pageCount, pageWidth: geometry.size.width)
    }
    
    private func onDragEnded(_ value: DragGesture.Value, geometry: GeometryProxy) {
        state.horizontalDragEnded(value, viewCount: pageCount, pageWidth: geometry.size.width)
    }
}

public struct VPageView<Pages>: View where Pages: View {
    let state: PageScrollState
    public let theme: PageControlTheme
    public let pages: Pages
    public let pageCount: Int
    
    public init(theme: PageControlTheme = .default, pageCount: Int, @ViewBuilder builder: () -> Pages) {
        self.state = PageScrollState()
        self.theme = theme
        self.pages = builder()
        self.pageCount = pageCount
    }
    
    public var body: some View {
        let pageControlBuilder = { (childCount, selectedPageBinding) in
            return PageControl.DefaultVertical(pageCount: childCount,
                                                 selectedPage: selectedPageBinding,
                                                 theme: self.theme)
        }
        
        return GeometryReader { geometry in
            PageContent(state: self.state,
                        axis: .vertical,
                        alignment: Alignment(horizontal: .center, vertical: .bottom),
                        geometry: geometry,
                        childCount: self.pageCount,
                        compositeView: VerticalPageStack(pages: self.pages, geometry: geometry),
                        pageControlBuilder: pageControlBuilder)
                .contentShape(Rectangle())
                   .gesture(DragGesture(minimumDistance: 8.0)
                       .onChanged({ self.onDragChanged($0, geometry: geometry) })
                       .onEnded({ self.onDragEnded($0, geometry: geometry) })
                   )
        }
    }
    
    private func onDragChanged(_ value: DragGesture.Value, geometry: GeometryProxy) {
        state.verticalDragChanged(value, viewCount: pageCount, pageHeight: geometry.size.height)
    }
    
    private func onDragEnded(_ value: DragGesture.Value, geometry: GeometryProxy) {
        state.verticalDragEnded(value, viewCount: pageCount, pageHeight: geometry.size.height)
    }
}
 
//public struct PageView<Pages>: View where Pages: View {
//    let state: PageScrollState
//    public let theme: PageControlTheme
//    public let pages: Pages
//    public let pageCount: Int
//    public let axis: PageAxis
//
//    public init(axis: PageAxis = .horizontal, theme: PageControlTheme = .default, pageCount: Int, @ViewBuilder builder: () -> Pages) {
//        self.state = PageScrollState()
//        self.theme = theme
//        self.pages = builder()
//        self.pageCount = pageCount
//        self.axis = axis
//    }
//
//    public var body: some View {
//        GeometryReader { geometry in
//            PageContent(state: self.state, theme: self.theme, axis: self.axis, geometry: geometry, childCount: self.pageCount, compositeView: self.pages)
//                .contentShape(Rectangle())
//                .gesture(DragGesture(minimumDistance: 8.0)
//                    .onChanged({ self.onDragChanged($0, geometry: geometry) })
//                    .onEnded({ self.onDragEnded($0, geometry: geometry) })
//                )
//        }
//    }
//
//    private func onDragChanged(_ value: DragGesture.Value, geometry: GeometryProxy) {
//        if case .horizontal(_) = axis {
//            state.horizontalDragChanged(value, viewCount: pageCount, pageWidth: geometry.size.width)
//        } else {
//            state.verticalDragChanged(value, viewCount: pageCount, pageHeight: geometry.size.height)
//        }
//    }
//
//    private func onDragEnded(_ value: DragGesture.Value, geometry: GeometryProxy) {
//        if case .horizontal(_) = axis {
//            state.horizontalDragEnded(value, viewCount: pageCount, pageWidth: geometry.size.width)
//        } else {
//            state.verticalDragEnded(value, viewCount: pageCount, pageHeight: geometry.size.height)
//        }
//    }
//}

#if DEBUG
struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        let v1 = VStack {
            Image(systemName: "heart.fill").resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.red)
            Text("Some title")
                .font(.system(size: 24))
                .fontWeight(.bold)
        }
        
        let v2 = VStack {
            Image(systemName: "heart").resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.red)
            Text("Some title")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .foregroundColor(.gray)
        }
        return HPageView(pageCount: 3) {
            v1
            v2
        }
    }
}
#endif
