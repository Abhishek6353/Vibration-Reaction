//
//  ContentView.swift
//  Vibration ReactionDemo
//
//  Created by Apple on 17/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var start = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Vibration Reaction")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Test your reaction time using vibration only. Tap when vibration stops.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button("Start Test") {
                start = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .fullScreenCover(isPresented: $start) {
            ReactionTestView()
        }
    }
}

