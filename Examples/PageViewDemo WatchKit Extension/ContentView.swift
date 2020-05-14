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
        HPageView {
            CustomButtonView()
            CustomButtonView()
            CustomButtonView()
            CustomView()
            CustomView()
            CustomView()
        }.edgesIgnoringSafeArea(.init(arrayLiteral: .leading, .trailing, .bottom))
        // Vertical
//        VPageView {
//            CustomView()
//            CustomListView()
//            CustomView()
//            CustomView()
//            CustomView()
//            CustomView()
//        }.edgesIgnoringSafeArea(.init(arrayLiteral: .leading, .trailing, .bottom))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
