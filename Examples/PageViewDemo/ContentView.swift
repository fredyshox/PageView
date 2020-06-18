//
//  ContentView.swift
//  PageViewDemo
//
//  Created by Kacper on 09/02/2020.
//  Copyright © 2020 Kacper. All rights reserved.
//

import SwiftUI
//import PageView

struct ContentView: View {
    @State var selectedPage = 2
    
    var body: some View {
        // horizontal
        HPageView(selectedPage: $selectedPage) {
            CustomView(pageIndex: 0)
            CustomListView(pageIndex: 1)
            CustomView(pageIndex: 2)
        }
        // vertical
//        VPageView(selectedPage: $selectedPage) {
//            CustomView(pageIndex: 0)
//            CustomView(pageIndex: 1)
//            CustomView(pageIndex: 2)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
