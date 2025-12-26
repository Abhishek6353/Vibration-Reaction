//
//  HapticsManager.swift
//  Vibration ReactionDemo
//
//  Created by Apple on 17/12/25.
//

import Foundation
import CoreHaptics

import UIKit

final class HapticsManager {

    private let generator = UIImpactFeedbackGenerator(style: .heavy)

    init() {
        generator.prepare()
    }

    func vibrateStart() {
        generator.impactOccurred()
    }

    func vibrateStop() {
        // No action needed — vibration is momentary
        // We simulate "continuous vibration" by repeating pulses
    }
}
