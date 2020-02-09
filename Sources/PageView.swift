//
//  PageView.swift
//  PageView
//
//  Created by Kacper on 09/02/2020.
//

import SwiftUI

public struct PageView: View {
    @State private var selectedPage: Int = 0
    @State private var contentOffsetX: CGFloat = 0.0
    @State private var scrollOffsetX: CGFloat = 0.0
    public let theme: PageControlTheme
    public let views: [AnyView]
    
    public init(theme: PageControlTheme = .default, pageCount: Int, pageContent: @escaping (Int) -> AnyView) {
        self.theme = theme
        self.views = (0..<pageCount).map { pageContent($0) }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                HStack(spacing: 0.0) {
                    ForEach(0..<self.views.count) { (i) in
                        self.views[i]
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                }
                    .offset(x: (geometry.size.width / 2) * CGFloat(self.views.count - 1) + self.contentOffsetX)
                PageControl(pageCount: self.views.count, theme: self.theme, selectedPage: self.$selectedPage)
                    .offset(y: -self.theme.offset)
            }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .contentShape(Rectangle())
                .gesture(DragGesture()
                    .onChanged(self.onDragChanged)
                    .onEnded({ self.onDragEnded($0, pageWidth: geometry.size.width) })
                )
        }
    }
    
    private func onDragChanged(_ value: DragGesture.Value) {
        let delta = value.location.x - value.startLocation.x
        contentOffsetX = scrollOffsetX + delta
    }
    
    private func onDragEnded(_ value: DragGesture.Value, pageWidth: CGFloat) {
        withAnimation(.easeInOut(duration: 0.25), {
            if self.contentOffsetX > 0 {
                self.contentOffsetX = 0
            } else if contentOffsetX < -(pageWidth * CGFloat(self.views.count - 1)) {
                self.contentOffsetX = -(pageWidth * CGFloat(self.views.count - 1))
            } else {
                let pageOffset = abs(contentOffsetX) - CGFloat(self.selectedPage) * pageWidth
                if pageOffset > 0.5*pageWidth {
                    self.selectedPage += 1
                } else if pageOffset < -0.5*pageWidth {
                    self.selectedPage -= 1
                }
                
                self.contentOffsetX = -CGFloat(self.selectedPage) * pageWidth
            }
            
            self.scrollOffsetX = self.contentOffsetX
        })
    }
}

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

