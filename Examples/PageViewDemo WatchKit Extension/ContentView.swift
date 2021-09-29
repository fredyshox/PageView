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
    @State var selectedPage: Int = 0
    
    var body: some View {
        // Horizontal
        HPageView(selectedPage: $selectedPage) {
            CustomButtonView(pageIndex: 0)
            CustomButtonView(pageIndex: 1)
            CustomButtonView(pageIndex: 2)
            CustomView(pageIndex: 3)
            CustomListView(pageIndex: 4)
            CustomView(pageIndex: 5)
        }.edgesIgnoringSafeArea(.init(arrayLiteral: .leading, .trailing, .bottom))
        
        // ForEach Horizontal
//        HPageView(selectedPage: $selectedPage, data: 0..<6) { i in
//            CustomButtonView(pageIndex: i)
//        }
//            .edgesIgnoringSafeArea(.init(arrayLiteral: .leading, .trailing, .bottom))
        
        // Vertical
//        VPageView(selectedPage: $selectedPage) {
//            CustomButtonView(pageIndex: 0)
//            CustomButtonView(pageIndex: 1)
//            CustomButtonView(pageIndex: 2)
//            CustomView(pageIndex: 3)
//            CustomView(pageIndex: 4)
//            CustomView(pageIndex: 5)
//        }.edgesIgnoringSafeArea(.init(arrayLiteral: .leading, .trailing, .bottom))
        
        // ForEach Vertical
//        VPageView(selectedPage: $selectedPage, data: 0..<6) { i in
//            CustomButtonView(pageIndex: i)
//        }
//            .edgesIgnoringSafeArea(.init(arrayLiteral: .leading, .trailing, .bottom))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
