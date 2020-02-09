//
//  Views.swift
//  PageViewDemo
//
//  Created by Kacper on 09/02/2020.
//  Copyright © 2020 Kacper. All rights reserved.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

struct CustomView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe").resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.orange)
            Text("Hello world")
                .font(.system(size: 24))
                .fontWeight(.bold)
        }
    }
}

struct CustomListView: View {
    var body: some View {
        List(0..<10) { (i) in
            HStack {
                Text("Cell \(i)")
                Spacer()
                Text("Detail")
            }
        }
    }
}
