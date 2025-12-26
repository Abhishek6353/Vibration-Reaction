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

    private var scoreDetails: (label: String, color: Color, icon: String) {
        if reactionTime < 200 {
            return ("Elite", .green, "bolt.fill")
        } else if reactionTime < 350 {
            return ("Great", .blue, "hand.thumbsup.fill")
        } else if reactionTime < 500 {
            return ("Average", .orange, "person.fill")
        } else {
            return ("Slow", .red, "tortoise.fill")
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Soft background glow
            Circle()
                .fill(scoreDetails.color.opacity(0.15))
                .blur(radius: 100)
                .offset(y: -100)

            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: scoreDetails.icon)
                        .font(.system(size: 60))
                        .foregroundColor(scoreDetails.color)
                        .padding(.bottom, 10)
                    
                    Text(scoreDetails.label)
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundColor(scoreDetails.color)
                    
                    Text("REACTION TIME")
                        .font(.caption)
                        .tracking(4)
                        .foregroundColor(.white.opacity(0.5))
                }

                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(Int(reactionTime))")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("ms")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.05))
                .cornerRadius(24)
                .padding(.horizontal, 40)

                Spacer()

                Button(action: onDone) {
                    Text("TRY AGAIN")
                        .font(.headline)
                        .tracking(2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 50)
            }
        }
    }
}

