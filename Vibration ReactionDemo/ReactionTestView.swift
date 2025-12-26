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
    @State private var statusColor: Color = .white
    @State private var vibrating = false
    @State private var vibrationEndTime: Date?
    @State private var reactionTime: Double?
    
    // Animation states
    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Pulsing background for vibration
            Circle()
                .fill(Color.red.opacity(0.3))
                .scaleEffect(pulseScale)
                .opacity(pulseOpacity)
                .frame(width: 300, height: 300)
                .blur(radius: 40)

            VStack(spacing: 32) {
                Text(statusText)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(statusColor)
                    .shadow(color: statusColor.opacity(0.3), radius: 10)
                    .scaleEffect(vibrating ? 1.1 : 1.0)
                
                if !vibrating && vibrationEndTime != nil {
                   Image(systemName: "hand.tap.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.cyan)
                        .transition(.scale.combined(with: .opacity))
                }
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
        statusColor = .white
        
        let delay = Double.random(in: 1.5...3.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            startVibration()
        }
    }

    private func startVibration() {
        vibrating = true
        statusText = "Vibrating…"
        statusColor = .red
        
        // Start pulsing animation
        withAnimation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
            pulseScale = 1.5
            pulseOpacity = 0.6
        }

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
        
        // Stop pulse animation
        withAnimation(.easeOut(duration: 0.2)) {
            pulseScale = 1.0
            pulseOpacity = 0.0
        }

        vibrationEndTime = Date()
        statusText = "TAP NOW!"
        statusColor = .cyan
    }

    private func handleTap() {
        if vibrating {
            statusText = "Too early!"
            statusColor = .orange
            restart()
            return
        }
        
        guard let endTime = vibrationEndTime else { return }

        let reaction = Date().timeIntervalSince(endTime) * 1000
        reactionTime = reaction
    }

    private func restart() {
        vibrationEndTime = nil
        vibrationTimer?.invalidate()
        vibrationTimer = nil
        vibrating = false
        
        withAnimation {
            pulseScale = 1.0
            pulseOpacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            startTest()
        }
    }
}
