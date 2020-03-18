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
    var body: some View {
        HPageView(pageCount: 3) {
            CustomView()
            CustomListView()
            CustomView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
