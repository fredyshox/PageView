//
//  PageView.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public struct PageView<Page>: View where Page: View {
    let state: PageScrollState
    public let theme: PageControlTheme
    public let views: [Page]
    public let axis: Axis
    
    public init(axis: Axis = .horizontal, theme: PageControlTheme = .default, pageCount: Int, pageContent: @escaping (Int) -> Page) {
        self.state = PageScrollState()
        self.theme = theme
        self.views = (0..<pageCount).map { pageContent($0) }
        self.axis = axis
    }
    
    public var body: some View {
        GeometryReader { geometry in
            PageContent(state: self.state, theme: self.theme, views: self.views, axis: self.axis, geometry: geometry)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 8.0)
                    .onChanged({ self.onDragChanged($0, geometry: geometry) })
                    .onEnded({ self.onDragEnded($0, geometry: geometry) })
                )
        }
    }
        
    private func onDragChanged(_ value: DragGesture.Value, geometry: GeometryProxy) {
        if axis == .horizontal {
            state.horizontalDragChanged(value, viewCount: views.count, pageWidth: geometry.size.width)
        } else {
            state.verticalDragChanged(value, viewCount: views.count, pageHeight: geometry.size.height)
        }
    }
    
    private func onDragEnded(_ value: DragGesture.Value, geometry: GeometryProxy) {
        if axis == .horizontal {
            state.horizontalDragEnded(value, viewCount: views.count, pageWidth: geometry.size.width)
        } else {
            state.verticalDragEnded(value, viewCount: views.count, pageHeight: geometry.size.height)
        }
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
        return PageView(pageCount: 3) { i in
            return i == 0 ? AnyView(v1) : AnyView(v2)
        }
    }
}
#endif
