//
//  PageView.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public struct PageViewSettings {
    public enum GestureType {
        case standard, simultaneous, highPriority
    }

    public var switchThreshold: CGFloat = .defaultSwitchThreshold
    public var dragEdgeThreshold: CGFloat = .defaultDragEdgeThreshold
    public var pageGestureType: GestureType = .highPriority
    public var dragEnabled: Bool = true

    public init(switchThreshold: CGFloat = .defaultSwitchThreshold, dragEdgeThreshold: CGFloat = .defaultDragEdgeThreshold, pageGestureType: GestureType = .highPriority, dragEnabled: Bool = true) {
        self.switchThreshold = switchThreshold
        self.dragEdgeThreshold = dragEdgeThreshold
        self.pageGestureType = pageGestureType
        self.dragEnabled = dragEnabled
    }

    public static let `default` = Self()
}

public struct HPageView<Pages>: View where Pages: View {
    @StateObject private var state = PageScrollState()
    @Binding var selectedPage: Int

    public let settings: PageViewSettings
    public let theme: PageControlTheme
    public let pages: PageContainer<Pages>
    public let pageCount: Int
    public let pageControlAlignment: Alignment
    
    public init(
        selectedPage: Binding<Int>,
        settings: PageViewSettings = .default,
        theme: PageControlTheme = .default,
        @PageViewBuilder builder: () -> PageContainer<Pages>
    ) {
        self._selectedPage = selectedPage
        self.settings = settings
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
                                                 theme: theme)
        }
        
        return GeometryReader { geometry in
            PageContent(selectedPage: $selectedPage,
                        state: state,
                        axis: .horizontal,
                        alignment: pageControlAlignment,
                        geometry: geometry,
                        childCount: pageCount,
                        compositeView: HorizontalPageStack(pages: pages, geometry: geometry),
                        pageControlBuilder: pageControlBuilder)
                .contentShape(Rectangle())
                .gesture(gesture(geometry: geometry),
                         including: settings.dragEnabled ? .all : .subviews,
                         type: settings.pageGestureType)
        }
    }

    func gesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 8.0)
                    .onChanged {
                        state.horizontalDragChanged($0,
                                                    viewCount: pageCount,
                                                    pageWidth: geometry.size.width,
                                                    settings: settings,
                                                    selectedPage: selectedPage)
                    }
                    .onEnded {
                        state.horizontalDragEnded($0,
                                                  viewCount: pageCount,
                                                  pageWidth: geometry.size.width,
                                                  settings: settings,
                                                  selectedPage: $selectedPage)
                    }
    }
}

public struct VPageView<Pages>: View where Pages: View {
    @StateObject private var state = PageScrollState()
    @Binding var selectedPage: Int

    public let settings: PageViewSettings
    public let theme: PageControlTheme
    public let pages: PageContainer<Pages>
    public let pageCount: Int
    public let pageControlAlignment: Alignment
    
    public init(
        selectedPage: Binding<Int>,
        settings: PageViewSettings = .default,
        theme: PageControlTheme = .default,
        @PageViewBuilder builder: () -> PageContainer<Pages>
    ) {
        self.settings = settings
        self._selectedPage = selectedPage
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
                                                 theme: theme)
        }
        
        return GeometryReader { geometry in
            PageContent(selectedPage: $selectedPage,
                        state: state,
                        axis: .vertical,
                        alignment: pageControlAlignment,
                        geometry: geometry,
                        childCount: pageCount,
                        compositeView: VerticalPageStack(pages: pages, geometry: geometry),
                        pageControlBuilder: pageControlBuilder)
                .contentShape(Rectangle())
                .gesture(gesture(geometry: geometry),
                         including: settings.dragEnabled ? .all : .subviews,
                         type: settings.pageGestureType)
        }
    }

    func gesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 8.0)
                    .onChanged {
                        state.verticalDragChanged($0,
                                                  viewCount: pageCount,
                                                  pageHeight: geometry.size.height,
                                                  settings: settings,
                                                  selectedPage: selectedPage)
                    }
                    .onEnded {
                        state.verticalDragEnded($0,
                                                viewCount: pageCount,
                                                pageHeight: geometry.size.height,
                                                settings: settings,
                                                selectedPage: $selectedPage)
                    }
    }
}

extension View {
    func gesture<T>(_ gesture: T, including mask: GestureMask = .all, type: PageViewSettings.GestureType) -> some View where T : Gesture {
        Group {
            if type == .standard {
                self
                    .gesture(gesture, including: mask)
            } else if type == .simultaneous {
                self
                    .simultaneousGesture(gesture, including: mask)
            } else if type == .highPriority {
                self
                    .highPriorityGesture(gesture, including: mask)
            } else {
                self
            }
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

    public static var defaultDragEdgeThreshold: CGFloat {
        0.5
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
