//
//  PageGestureType.swift
//  PageView
//
//  Created by Kacper Rączy on 29/09/2021.
//

import SwiftUI

public enum PageGestureType {
    case standard, simultaneous, highPriority
}

extension View {
    func gesture<G>(_ gesture: G, type: PageGestureType, including mask: GestureMask = .all) -> some View where G: Gesture {
        Group {
            if type == .simultaneous {
                self.simultaneousGesture(gesture, including: mask)
            } else if type == .highPriority {
                self.highPriorityGesture(gesture, including: mask)
            } else {
                self.gesture(gesture, including: mask)
            }
        }
    }
}
