//
//  ResultView.swift
//  Vibration ReactionDemo
//
//  Created by Apple on 17/12/25.
//

import SwiftUI

struct ResultView: View {
    let reactionTime: Double
    let onDone: () -> Void

    private var rating: String {
        switch reactionTime {
        case ..<200: return "Fast"
        case 200..<350: return "Average"
        default: return "Slow"
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Reaction Time")
                .font(.headline)

            Text("\(Int(reactionTime)) ms")
                .font(.system(size: 56, weight: .bold))

            Text(rating)
                .font(.title2)

            Button("Done", action: onDone)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

