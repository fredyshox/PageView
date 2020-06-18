//
//  PageScrollState.swift
//  PageView
//
//  Created by Kacper Raczy on 11/02/2020.
//

import SwiftUI

class PageScrollState: ObservableObject {
    @Published var selectedPage: Int = 0
    @Published var pageOffset: CGFloat = 0.0
    @Published var isGestureActive: Bool = false
    
    func horizontalDragChanged(_ value: DragGesture.Value, viewCount: Int, pageWidth: CGFloat) {
        isGestureActive = true
        let delta = value.translation.width
        if (delta > 0 && selectedPage == 0) || (delta < 0 && selectedPage == viewCount - 1) {
            pageOffset = delta / 3.0
        } else {
            pageOffset = delta
        }
    }
    
    func horizontalDragEnded(_ value: DragGesture.Value, viewCount: Int, pageWidth: CGFloat) {
        dragEnded(value, viewCount: viewCount, dimension: pageWidth)
    }
    
    func verticalDragChanged(_ value: DragGesture.Value, viewCount: Int, pageHeight: CGFloat) {
        isGestureActive = true
        let delta = value.translation.height
        if (delta > 0 && selectedPage == 0) || (delta < 0 && selectedPage == viewCount - 1) {
            pageOffset = delta / 3.0
        } else {
            pageOffset = delta
        }
    }
    
    func verticalDragEnded(_ value: DragGesture.Value, viewCount: Int, pageHeight: CGFloat) {
        dragEnded(value, viewCount: viewCount, dimension: pageHeight)
    }
    
    private func dragEnded(_ value: DragGesture.Value, viewCount: Int, dimension: CGFloat) {
        var newPage = selectedPage
        if pageOffset > 0.5*dimension && selectedPage != 0 {
            newPage -= 1
        } else if pageOffset < -0.5*dimension && selectedPage != viewCount - 1 {
            newPage += 1
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            self.pageOffset = 0.0
            self.selectedPage = newPage
        }
        
        DispatchQueue.main.async {
            self.isGestureActive = false
        }
    }
}
