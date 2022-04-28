//
//  ContentView.swift
//  PageViewDemo
//
//  Created by Kacper on 09/02/2020.
//  Copyright © 2020 Kacper. All rights reserved.
//

import SwiftUI
import PageView

struct ContentView: View {
    @State var selectedPage = 2
    
    var body: some View {
        // Horizontal
        HPageView(selectedPage: $selectedPage) {
            CustomView(pageIndex: 0)
            CustomListView(pageIndex: 1)
            CustomView(pageIndex: 2)
        }
        
        // ForEach Horizontal
//        HPageView(selectedPage: $selectedPage, data: 0..<6) { i in
//            CustomView(pageIndex: i)
//        }
        
        // Vertical
//        VPageView(selectedPage: $selectedPage) {
//            CustomView(pageIndex: 0)
//            CustomView(pageIndex: 1)
//            CustomView(pageIndex: 2)
//        }
        
        // ForEach Vertical
//        VPageView(selectedPage: $selectedPage, data: 0..<6) { i in
//            CustomView(pageIndex: i)
//        }
    }
}

extension Int: Identifiable {
    public var id: Int {
        return self
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
