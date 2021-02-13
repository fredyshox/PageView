//
//  PageScrollState.swift
//  PageView
//
//  Created by Kacper Raczy on 11/02/2020.
//

import SwiftUI

public enum PageGestureType {
    case disabled, standard, simultaneous, highPriority
}

class PageScrollState: ObservableObject {
    // MARK: Properties
    @Published var pageOffset: CGFloat = 0.0
    @Published var isGestureActive: Bool = false

    func willAcceptHorizontalDrag(_ value: DragGesture.Value, pageWidth: CGFloat, settings: PageViewSettings) -> Bool {
        guard settings.dragEnabled else { return false }

        let allowedRange = pageWidth * settings.dragEdgeThreshold

        return (0 ... allowedRange).contains(value.startLocation.x) || (pageWidth - allowedRange ... pageWidth).contains(value.startLocation.x)
    }

    func willAcceptVerticalDrag(_ value: DragGesture.Value, pageHeight: CGFloat, settings: PageViewSettings) -> Bool {
        guard settings.dragEnabled else { return false }

        let allowedRange = pageHeight * settings.dragEdgeThreshold

        return (0 ... allowedRange).contains(value.startLocation.y) || (pageHeight - allowedRange ... pageHeight).contains(value.startLocation.y)
    }

    func willAcceptHorizontalDrag(_ value: DragGesture.Value, pageWidth: CGFloat) -> Bool {
        guard pageGestureType != .disabled else { return false }

        let allowedRange = pageWidth * edgeSwipeThreshold

        return (0 ... allowedRange).contains(value.startLocation.x) || (pageWidth - allowedRange ... pageWidth).contains(value.startLocation.x)
    }

    func willAcceptVerticalDrag(_ value: DragGesture.Value, pageHeight: CGFloat) -> Bool {
        guard pageGestureType != .disabled else { return false }

        let allowedRange = pageHeight * edgeSwipeThreshold

        return (0 ... allowedRange).contains(value.startLocation.y) || (pageHeight - allowedRange ... pageHeight).contains(value.startLocation.y)
    }
    
    // MARK: DragGesture callbacks
    
    func horizontalDragChanged(_ value: DragGesture.Value, viewCount: Int, pageWidth: CGFloat, settings: PageViewSettings, selectedPage: Int) {
        guard willAcceptHorizontalDrag(value, pageWidth: pageWidth, settings: settings) else { return }

        isGestureActive = true
        let delta = value.translation.width
        if (delta > 0 && selectedPage == 0) || (delta < 0 && selectedPage == viewCount - 1) {
            pageOffset = delta / 3.0
        } else {
            pageOffset = delta
        }
    }
    
    func horizontalDragEnded(_ value: DragGesture.Value, viewCount: Int, pageWidth: CGFloat, settings: PageViewSettings, selectedPage: Binding<Int>) {
        guard willAcceptHorizontalDrag(value, pageWidth: pageWidth, settings: settings) else { return }

        dragEnded(value, viewCount: viewCount, dimension: pageWidth, settings: settings, selectedPage: selectedPage)
    }
    
    func verticalDragChanged(_ value: DragGesture.Value, viewCount: Int, pageHeight: CGFloat, settings: PageViewSettings, selectedPage: Int) {
        guard willAcceptVerticalDrag(value, pageHeight: pageHeight, settings: settings) else { return }

        isGestureActive = true
        let delta = value.translation.height
        if (delta > 0 && selectedPage == 0) || (delta < 0 && selectedPage == viewCount - 1) {
            pageOffset = delta / 3.0
        } else {
            pageOffset = delta
        }
    }
    
    func verticalDragEnded(_ value: DragGesture.Value, viewCount: Int, pageHeight: CGFloat, settings: PageViewSettings, selectedPage: Binding<Int>) {
        guard willAcceptVerticalDrag(value, pageHeight: pageHeight, settings: settings) else { return }

        dragEnded(value, viewCount: viewCount, dimension: pageHeight, settings: settings, selectedPage: selectedPage)
    }
    
    private func dragEnded(_ value: DragGesture.Value, viewCount: Int, dimension: CGFloat, settings: PageViewSettings, selectedPage: Binding<Int>) {
        var newPage = selectedPage.wrappedValue
        if pageOffset > settings.switchThreshold * dimension && selectedPage.wrappedValue != 0 {
            newPage -= 1
        } else if pageOffset < -settings.switchThreshold * dimension && selectedPage.wrappedValue != viewCount - 1 {
            newPage += 1
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            pageOffset = 0.0
            selectedPage.wrappedValue = newPage
        }
        
        DispatchQueue.main.async {
            self.isGestureActive = false
        }
    }
}
