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
    @GestureState var stateTransaction: PageScrollState.TransactionInfo
    
    public init(
        selectedPage: Binding<Int>,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        theme: PageControlTheme = .default,
        @PageViewBuilder builder: () -> PageContainer<Pages>
    ) {
        // prevent values outside of 0...1
        let threshold = CGFloat(abs(pageSwitchThreshold) - floor(abs(pageSwitchThreshold)))
        self.state = PageScrollState(switchThreshold: threshold, selectedPageBinding: selectedPage)
        self.theme = theme
        let pages = builder()
        self.pages = pages
        self.pageCount = pages.count
        self.pageControlAlignment =
            theme.alignment ?? Alignment(horizontal: .center, vertical: .bottom)
        self._stateTransaction = state.horizontalGestureState(pageCount: pages.count)
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
                .simultaneousGesture(DragGesture(minimumDistance: 8.0)
                    .updating(self.$stateTransaction, body: { value, state, _ in
                        state.dragValue = value
                        state.geometryProxy = geometry
                    })
                    .onChanged({
                        let width = geometry.size.width
                        let pageCount = self.pageCount
                        self.state.horizontalDragChanged($0, viewCount: pageCount, pageWidth: width)
                    })
                    /*
                     There is a bug, where onEnded is not called, when gesture is cancelled.
                     So onEnded is handled using reset handler in `GestureState` (look `PageScrollState`)
                    */
                )
        }
    }
}

public struct VPageView<Pages>: View where Pages: View {
    let state: PageScrollState
    public let theme: PageControlTheme
    public let pages: PageContainer<Pages>
    public let pageCount: Int
    public let pageControlAlignment: Alignment
    @GestureState var stateTransaction: PageScrollState.TransactionInfo
    
    public init(
        selectedPage: Binding<Int>,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        theme: PageControlTheme = .default,
        @PageViewBuilder builder: () -> PageContainer<Pages>
    ) {
        // prevent values outside of 0...1
        let threshold = CGFloat(abs(pageSwitchThreshold) - floor(abs(pageSwitchThreshold)))
        self.state = PageScrollState(switchThreshold: threshold, selectedPageBinding: selectedPage)
        self.theme = theme
        let pages = builder()
        self.pages = pages
        self.pageCount = pages.count
        self.pageControlAlignment =
            theme.alignment ?? Alignment(horizontal: .leading, vertical: .center)
        self._stateTransaction = state.verticalGestureState(pageCount: pages.count)
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
                .simultaneousGesture(DragGesture(minimumDistance: 8.0)
                    .updating(self.$stateTransaction, body: { value, state, _ in
                        state.dragValue = value
                        state.geometryProxy = geometry
                    })
                    .onChanged({
                        let height = geometry.size.height
                        let pageCount = self.pageCount
                        self.state.verticalDragChanged($0, viewCount: pageCount, pageHeight: height)
                    })
                    /*
                     There is a bug, where onEnded is not called, when gesture is cancelled.
                     So onEnded is handled using reset handler in `GestureState`. (look `PageScrollState`)
                    */
                )
        }
    }
}

extension CGFloat {
    public static var defaultSwitchThreshold: CGFloat {
        #if os(iOS)
        return 0.3
        #elseif os(watchOS)
        return 0.5
        #else
        return 0.5
        #endif
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

        var theme = PageControlTheme.default
        theme.alignment = Alignment(horizontal: .center, vertical: .bottom)
        theme.yOffset = -14

        var pageIndex = 0
        let pageBinding = Binding(get: {
            return pageIndex
        }, set: { i in
            pageIndex = i
        })
        
        return HPageView(selectedPage: pageBinding, theme: theme) {
            v1
            v2
        }
    }
}
#endif
