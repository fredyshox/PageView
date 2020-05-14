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
    public let pages: PageContainer<Pages>
    public let pageCount: Int
    public let pageControlAlignment: Alignment
    
    public init(theme: PageControlTheme = .default, @PageViewBuilder builder: () -> PageContainer<Pages>) {
        self.state = PageScrollState()
        self.theme = theme
        let pages = builder()
        self.pages = pages
        self.pageCount = pages.count
        self.pageControlAlignment =
            theme.alignment ?? Alignment(horizontal: .center, vertical: .bottom)
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
                        alignment: self.pageControlAlignment,
                        geometry: geometry,
                        childCount: self.pageCount,
                        compositeView: HorizontalPageStack(pages: self.pages, geometry: geometry),
                        pageControlBuilder: pageControlBuilder)
                .contentShape(Rectangle())
                .highPriorityGesture(DragGesture(minimumDistance: 8.0)
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
    public let pages: PageContainer<Pages>
    public let pageCount: Int
    public let pageControlAlignment: Alignment
    
    public init(theme: PageControlTheme = .default, @PageViewBuilder builder: () -> PageContainer<Pages>) {
        self.state = PageScrollState()
        self.theme = theme
        let pages = builder()
        self.pages = pages
        self.pageCount = pages.count
        self.pageControlAlignment =
            theme.alignment ?? Alignment(horizontal: .leading, vertical: .center)
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
                        alignment: self.pageControlAlignment,
                        geometry: geometry,
                        childCount: self.pageCount,
                        compositeView: VerticalPageStack(pages: self.pages, geometry: geometry),
                        pageControlBuilder: pageControlBuilder)
                .contentShape(Rectangle())
                .highPriorityGesture(DragGesture(minimumDistance: 8.0)
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
        return HPageView {
            v1
            v2
        }
    }
}
#endif
