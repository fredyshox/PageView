//
//  PageScrollState.swift
//  PageView
//
//  Created by Kacper Raczy on 11/02/2020.
//

import SwiftUI

final class PageScrollState: ObservableObject {
    
    // MARK: Types
    
    struct TransactionInfo {
        var dragValue: DragGesture.Value!
        var geometryProxy: GeometryProxy!
    }
    
    // MARK: Properties
    
    let switchThreshold: CGFloat
    @Binding var selectedPage: Int
    @Published var pageOffset: CGFloat = 0.0
    @Published var isGestureActive: Bool = false
    
    init(switchThreshold: CGFloat, selectedPageBinding: Binding<Int>) {
        self.switchThreshold = switchThreshold
        self._selectedPage = selectedPageBinding
    }
    
    // MARK: DragGesture callbacks
    
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
        if pageOffset > switchThreshold*dimension && selectedPage != 0 {
            newPage -= 1
        } else if pageOffset < -switchThreshold*dimension && selectedPage != viewCount - 1 {
            newPage += 1
        }
        
        withAnimation(.easeOut(duration: 0.2)) {
            self.pageOffset = 0.0
            self.selectedPage = newPage
        }
        
        DispatchQueue.main.async {
            self.isGestureActive = false
        }
    }
    
    // MARK: Gesture States
    
    func horizontalGestureState(pageCount: Int) -> GestureState<TransactionInfo> {
        return GestureState(initialValue: TransactionInfo()) { [weak self] (info, _) in
            let width = info.geometryProxy.size.width
            let dragValue = info.dragValue!
            self?.horizontalDragEnded(dragValue, viewCount: pageCount, pageWidth: width)
        }
    }
    
    func verticalGestureState(pageCount: Int) -> GestureState<TransactionInfo> {
        return GestureState(initialValue: TransactionInfo()) { [weak self] (info, _) in
            let height = info.geometryProxy.size.height
            let dragValue = info.dragValue!
            self?.verticalDragEnded(dragValue, viewCount: pageCount, pageHeight: height)
        }
    }
}
