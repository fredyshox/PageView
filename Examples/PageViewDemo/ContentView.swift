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
    var body: some View {
        PageView(pageCount: 3) { (i) -> AnyView in
            if i == 0 {
                return CustomView().eraseToAnyView()
            } else if i == 1 {
                return CustomListView().eraseToAnyView()
            } else {
                return CustomView().eraseToAnyView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
