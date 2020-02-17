//
//  PageScrollState.swift
//  PageView
//
//  Created by Kacper Raczy on 11/02/2020.
//

import SwiftUI

class PageScrollState: ObservableObject {
    @Published var selectedPage: Int = 0
    @Published var contentOffset: CGFloat = 0.0
    @Published var isGestureActive: Bool = false
    var scrollOffset: CGFloat = 0.0
    
    func horizontalDragChanged(_ value: DragGesture.Value, viewCount: Int, pageWidth: CGFloat) {
        isGestureActive = true
        let delta = value.translation.width
        if (delta > 0 && selectedPage == 0) || (delta < 0 && selectedPage == viewCount - 1) {
            contentOffset = scrollOffset + delta / 3.0
        } else {
            contentOffset = scrollOffset + delta
        }
    }
    
    func horizontalDragEnded(_ value: DragGesture.Value, viewCount: Int, pageWidth: CGFloat) {
        dragEnded(value, viewCount: viewCount, dimension: pageWidth)
    }
    
    func verticalDragChanged(_ value: DragGesture.Value, viewCount: Int, pageHeight: CGFloat) {
        isGestureActive = true
        let delta = value.translation.height
        if (delta > 0 && selectedPage == 0) || (delta < 0 && selectedPage == viewCount - 1) {
            contentOffset = scrollOffset + delta / 3.0
        } else {
            contentOffset = scrollOffset + delta
        }
    }
    
    func verticalDragEnded(_ value: DragGesture.Value, viewCount: Int, pageHeight: CGFloat) {
        dragEnded(value, viewCount: viewCount, dimension: pageHeight)
    }
    
    private func dragEnded(_ value: DragGesture.Value, viewCount: Int, dimension: CGFloat) {
        var newOffset = contentOffset
        var newPage = selectedPage
        if contentOffset > 0 {
             newOffset = 0
        } else if contentOffset < -(dimension * CGFloat(viewCount - 1)) {
             newOffset = -(dimension * CGFloat(viewCount - 1))
        } else {
            let pageOffset = abs(contentOffset) - CGFloat(selectedPage) * dimension
            if pageOffset > 0.5*dimension {
                newPage += 1
            } else if pageOffset < -0.5*dimension {
                newPage -= 1
            }
             
            newOffset = -CGFloat(newPage) * dimension
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            self.contentOffset = newOffset
            self.selectedPage = newPage
            self.scrollOffset = self.contentOffset
        }
        
        DispatchQueue.main.async {
            self.isGestureActive = false
        }
    }
}
