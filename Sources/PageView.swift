//
//  PageView.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public struct HPageView<Pages>: View where Pages: View {
    public let theme: PageControlTheme
    public let pages: PageContainer<Pages>
    public let pageCount: Int
    public let pageControlAlignment: Alignment
    public let pageGestureType: PageGestureType
    
    @StateObject var state: PageScrollState
    @GestureState var stateTransaction: PageScrollState.TransactionInfo
    
    public init(
        selectedPage: Binding<Int>,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        pageGestureType: PageGestureType = .highPriority,
        theme: PageControlTheme = .default,
        @PageViewBuilder builder: () -> PageContainer<Pages>
    ) {
        let pages = builder()
        self.init(
            selectedPage: selectedPage,
            pageCount: pages.count,
            pageContainer: pages,
            pageSwitchThreshold: pageSwitchThreshold,
            pageGestureType: pageGestureType,
            theme: theme
        )
    }
    
    public init<Data: RandomAccessCollection, ForEachContent: View>(
        selectedPage: Binding<Int>,
        data: Data,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        pageGestureType: PageGestureType = .highPriority,
        theme: PageControlTheme = .default,
        builder: @escaping (Data.Element) -> ForEachContent
    ) where Data.Element: Identifiable, Pages == ForEach<Data, Data.Element.ID, ForEachContent> {
        let forEachContainer = PageContainer(count: data.count, content: ForEach(data, content: builder))
        self.init(
            selectedPage: selectedPage,
            pageCount: data.count,
            pageContainer: forEachContainer,
            pageSwitchThreshold: pageSwitchThreshold,
            pageGestureType: pageGestureType,
            theme: theme
        )
    }
    
    public init<Data: RandomAccessCollection, ID: Identifiable, ForEachContent: View>(
        selectedPage: Binding<Int>,
        data: Data,
        idKeyPath: KeyPath<Data.Element, ID>,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        pageGestureType: PageGestureType = .highPriority,
        theme: PageControlTheme = .default,
        builder: @escaping (Data.Element) -> ForEachContent
    ) where Pages == ForEach<Data, ID, ForEachContent> {
        let forEachContainer = PageContainer(count: data.count, content: ForEach(data, id: idKeyPath, content: builder))
        self.init(
            selectedPage: selectedPage,
            pageCount: data.count,
            pageContainer: forEachContainer,
            pageSwitchThreshold: pageSwitchThreshold,
            pageGestureType: pageGestureType,
            theme: theme
        )
    }
    
    public init<ForEachContent: View>(
        selectedPage: Binding<Int>,
        data: Range<Int>,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        pageGestureType: PageGestureType = .highPriority,
        theme: PageControlTheme = .default,
        builder: @escaping (Int) -> ForEachContent
    ) where Pages == ForEach<Range<Int>, Int, ForEachContent> {
        let forEachContainer = PageContainer(count: data.count, content: ForEach(data, id: \.self, content: builder))
        self.init(
            selectedPage: selectedPage,
            pageCount: data.count,
            pageContainer: forEachContainer,
            pageSwitchThreshold: pageSwitchThreshold,
            pageGestureType: pageGestureType,
            theme: theme
        )
    }
    
    private init(
        selectedPage: Binding<Int>,
        pageCount: Int,
        pageContainer: PageContainer<Pages>,
        pageSwitchThreshold: CGFloat,
        pageGestureType: PageGestureType,
        theme: PageControlTheme
    ) {
        // prevent values outside of 0...1
        let threshold = CGFloat(abs(pageSwitchThreshold) - floor(abs(pageSwitchThreshold)))
        let wrappedStateObj = PageScrollState(switchThreshold: threshold, selectedPageBinding: selectedPage)
        self._state = StateObject(wrappedValue: wrappedStateObj)
        self._stateTransaction = wrappedStateObj.horizontalGestureState(pageCount: pageCount)
        self.theme = theme
        self.pages = pageContainer
        self.pageCount = pageCount
        self.pageControlAlignment =
            theme.alignment ?? Alignment(horizontal: .center, vertical: .bottom)
        self.pageGestureType = pageGestureType
    }
    
    public var body: some View {
        let pageControlBuilder = { (childCount, selectedPageBinding) in
            return PageControl.DefaultHorizontal(pageCount: childCount,
                                                 selectedPage: selectedPageBinding,
                                                 theme: self.theme)
        }
        
        return GeometryReader { geometry in
            PageContent(selectedPage: state.$selectedPage,
                        pageOffset: $state.pageOffset,
                        isGestureActive: $state.isGestureActive,
                        axis: .horizontal,
                        alignment: self.pageControlAlignment,
                        geometry: geometry,
                        childCount: self.pageCount,
                        compositeView: HorizontalPageStack(pages: self.pages, geometry: geometry),
                        pageControlBuilder: pageControlBuilder)
                .contentShape(Rectangle())
                .gesture(
                    dragGesture(geometry: geometry),
                    type: pageGestureType
                )
        }
    }
    
    private func dragGesture(geometry: GeometryProxy) -> some Gesture {
        /*
         There is a bug, where onEnded is not called, when gesture is cancelled.
         So onEnded is handled using reset handler in `GestureState` (look `PageScrollState`)
        */
        DragGesture(minimumDistance: 8.0)
            .updating(self.$stateTransaction, body: { value, state, _ in
                state.dragValue = value
                state.geometryProxy = geometry
            })
            .onChanged({
                let width = geometry.size.width
                let pageCount = self.pageCount
                self.state.horizontalDragChanged($0, viewCount: pageCount, pageWidth: width)
            })
    }
}

public struct VPageView<Pages>: View where Pages: View {
    public let theme: PageControlTheme
    public let pages: PageContainer<Pages>
    public let pageCount: Int
    public let pageControlAlignment: Alignment
    public let pageGestureType: PageGestureType
    
    @StateObject var state: PageScrollState
    @GestureState var stateTransaction: PageScrollState.TransactionInfo

    public init(
        selectedPage: Binding<Int>,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        pageGestureType: PageGestureType = .highPriority,
        theme: PageControlTheme = .default,
        @PageViewBuilder builder: () -> PageContainer<Pages>
    ) {
        let pages = builder()
        self.init(
            selectedPage: selectedPage,
            pageCount: pages.count,
            pageContainer: pages,
            pageSwitchThreshold: pageSwitchThreshold,
            pageGestureType: pageGestureType,
            theme: theme
        )
    }

    public init<Data: RandomAccessCollection, ForEachContent: View>(
        selectedPage: Binding<Int>,
        data: Data,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        pageGestureType: PageGestureType = .highPriority,
        theme: PageControlTheme = .default,
        builder: @escaping (Data.Element) -> ForEachContent
    ) where Data.Element: Identifiable, Pages == ForEach<Data, Data.Element.ID, ForEachContent> {
        let forEachContainer = PageContainer(count: data.count, content: ForEach(data, content: builder))
        self.init(
            selectedPage: selectedPage,
            pageCount: data.count,
            pageContainer: forEachContainer,
            pageSwitchThreshold: pageSwitchThreshold,
            pageGestureType: pageGestureType,
            theme: theme
        )
    }

    public init<Data: RandomAccessCollection, ID: Identifiable, ForEachContent: View>(
        selectedPage: Binding<Int>,
        data: Data,
        idKeyPath: KeyPath<Data.Element, ID>,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        pageGestureType: PageGestureType = .highPriority,
        theme: PageControlTheme = .default,
        builder: @escaping (Data.Element) -> ForEachContent
    ) where Pages == ForEach<Data, ID, ForEachContent> {
        let forEachContainer = PageContainer(count: data.count, content: ForEach(data, id: idKeyPath, content: builder))
        self.init(
            selectedPage: selectedPage,
            pageCount: data.count,
            pageContainer: forEachContainer,
            pageSwitchThreshold: pageSwitchThreshold,
            pageGestureType: pageGestureType,
            theme: theme
        )
    }

    public init<ForEachContent: View>(
        selectedPage: Binding<Int>,
        data: Range<Int>,
        pageSwitchThreshold: CGFloat = .defaultSwitchThreshold,
        pageGestureType: PageGestureType = .highPriority,
        theme: PageControlTheme = .default,
        builder: @escaping (Int) -> ForEachContent
    ) where Pages == ForEach<Range<Int>, Int, ForEachContent> {
        let forEachContainer = PageContainer(count: data.count, content: ForEach(data, id: \.self, content: builder))
        self.init(
            selectedPage: selectedPage,
            pageCount: data.count,
            pageContainer: forEachContainer,
            pageSwitchThreshold: pageSwitchThreshold,
            pageGestureType: pageGestureType,
            theme: theme
        )
    }

    private init(
        selectedPage: Binding<Int>,
        pageCount: Int,
        pageContainer: PageContainer<Pages>,
        pageSwitchThreshold: CGFloat,
        pageGestureType: PageGestureType,
        theme: PageControlTheme
    ) {
        // prevent values outside of 0...1
        let threshold = CGFloat(abs(pageSwitchThreshold) - floor(abs(pageSwitchThreshold)))
        let wrappedStateObj = PageScrollState(switchThreshold: threshold, selectedPageBinding: selectedPage)
        self._state = StateObject(wrappedValue: wrappedStateObj)
        self._stateTransaction = wrappedStateObj.verticalGestureState(pageCount: pageCount)
        self.theme = theme
        self.pages = pageContainer
        self.pageCount = pageCount
        self.pageControlAlignment =
            theme.alignment ?? Alignment(horizontal: .leading, vertical: .center)
        self.pageGestureType = pageGestureType
    }

    public var body: some View {
        let pageControlBuilder = { (childCount, selectedPageBinding) in
            return PageControl.DefaultVertical(pageCount: childCount,
                                                 selectedPage: selectedPageBinding,
                                                 theme: self.theme)
        }

        return GeometryReader { geometry in
            PageContent(selectedPage: state.$selectedPage,
                        pageOffset: $state.pageOffset,
                        isGestureActive: $state.isGestureActive,
                        axis: .vertical,
                        alignment: self.pageControlAlignment,
                        geometry: geometry,
                        childCount: self.pageCount,
                        compositeView: VerticalPageStack(pages: self.pages, geometry: geometry),
                        pageControlBuilder: pageControlBuilder)
                .contentShape(Rectangle())
                .gesture(
                    dragGesture(geometry: geometry),
                    type: pageGestureType
                )
        }
    }

    private func dragGesture(geometry: GeometryProxy) -> some Gesture {
        /*
         There is a bug, where onEnded is not called, when gesture is cancelled.
         So onEnded is handled using reset handler in `GestureState` (look `PageScrollState`)
        */
        DragGesture(minimumDistance: 8.0)
            .updating(self.$stateTransaction, body: { value, state, _ in
                state.dragValue = value
                state.geometryProxy = geometry
            })
            .onChanged({
                let height = geometry.size.height
                let pageCount = self.pageCount
                self.state.verticalDragChanged($0, viewCount: pageCount, pageHeight: height)
            })
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
