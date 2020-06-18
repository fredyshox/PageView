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

struct CustomButtonView: View {
    let pageIndex: Int
    
    var body: some View {
        VStack {
            Button(action: {
                print("Button 1 tapped")
            }, label: {
                Text("Button 1 at \(pageIndex)")
            })
            Button(action: {
                print("Button 2 tapped")
            }, label: {
                Text("Button 2 at \(pageIndex)")
            })
        }
    }
}

struct CustomView: View {
    let pageIndex: Int
    
    var body: some View {
        VStack {
            Image(systemName: "globe").resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
            Text("Hello world: \(pageIndex)")
                .font(.system(size: 24))
                .fontWeight(.bold)
        }
    }
}

struct CustomListView: View {
    let pageIndex: Int
    
    var body: some View {
        List(0..<10) { (i) in
            HStack {
                Text("Cell \(i)")
                Spacer()
                Text("Page index: \(self.pageIndex)")
            }
        }
    }
}
