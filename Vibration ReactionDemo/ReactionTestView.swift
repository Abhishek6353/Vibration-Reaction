//
//  ReactionTestView.swift
//  Vibration ReactionDemo
//
//  Created by Apple on 17/12/25.
//

import SwiftUI

struct ReactionTestView: View {
    @Environment(\.dismiss) private var dismiss
    private let haptics = HapticsManager()
    @State private var vibrationTimer: Timer?

    @State private var statusText = "Get Ready…"
    @State private var vibrating = false
    @State private var vibrationEndTime: Date?
    @State private var reactionTime: Double?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 32) {
                Text(statusText)
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            startTest()
        }
        .onTapGesture {
            handleTap()
        }
        .fullScreenCover(isPresented: .constant(reactionTime != nil)) {
            if let time = reactionTime {
                ResultView(reactionTime: time) {
                    dismiss()
                }
            }
        }

    }

    private func startTest() {
        statusText = "Get Ready…"

        let delay = Double.random(in: 1.5...3.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            startVibration()
        }
    }

    private func startVibration() {
        vibrating = true
        statusText = "Vibrating…"

        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
            haptics.vibrateStart()
        }

        let duration = Double.random(in: 1.0...2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            stopVibration()
        }
    }


    private func stopVibration() {
        vibrating = false
        vibrationTimer?.invalidate()
        vibrationTimer = nil

        vibrationEndTime = Date()
        statusText = "Tap Now!"
    }


    private func handleTap() {
        guard let endTime = vibrationEndTime else { return }

        if vibrating {
            statusText = "Too early — wait"
            restart()
            return
        }

        let reaction = Date().timeIntervalSince(endTime) * 1000
        reactionTime = reaction
    }

    private func restart() {
        vibrationEndTime = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            startTest()
        }
    }
}
