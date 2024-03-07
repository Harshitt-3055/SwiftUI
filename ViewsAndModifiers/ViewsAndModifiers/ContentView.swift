//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Harshit Agarwal on 23/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Hello World")
            VStack{
                Text("Hii ")
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(.red)
        
    }
}

#Preview {
    ContentView()
}
