//
//  ContentView.swift
//  Animations
//
//  Created by Harshit Agarwal on 29/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 1.0
    var body: some View {
        Button("Tap me ") {
            animationAmount += 1
        }
        .padding(100)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount)
        .blur(radius: (animationAmount - 1) * 1)
        .animation(.default, value: animationAmount)
    }
}

#Preview {
    ContentView()
}
