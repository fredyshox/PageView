//
//  ContentView.swift
//  PageViewDemo WatchKit Extension
//
//  Created by Kacper on 09/02/2020.
//  Copyright © 2020 Kacper. All rights reserved.
//

import SwiftUI
//import PageView

struct ContentView: View {
    var body: some View {
        // Horizontal
        HPageView(pageCount: 6) {
            CustomView()
            CustomListView()
            CustomView()
            CustomView()
            CustomView()
            CustomView()
        }.edgesIgnoringSafeArea([.leading, .trailing, .bottom])
        // Vertical
//        PageView(axis: .vertical(alignment: Alignment(horizontal: .trailing, vertical: .top)), pageCount: 3) { (i) -> AnyView in
//            if i == 0 {
//                return CustomView().eraseToAnyView()
//            } else if i == 1 {
//                return CustomView().eraseToAnyView()
//            } else {
//                return CustomView().eraseToAnyView()
//            }
//        }.edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
