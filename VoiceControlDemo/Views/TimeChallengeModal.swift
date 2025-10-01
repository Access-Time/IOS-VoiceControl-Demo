//
//  TimeChallengeModal.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import SwiftUI

struct TimeChallengeModal: View {
    @Binding var isPresented: Bool
    @State private var timeRemaining: Int = 5
    @State private var sequence: [Int] = [1, 2, 3, 4]
    @State private var currentStep: Int = 0
    @State private var hasWon: Bool = false
    @State private var hasFailed: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                if !hasWon && !hasFailed {
                    Text("🎉 Win a Free Cat! 🎉")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Time: \(timeRemaining)s")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(timeRemaining <= 2 ? .red : .white)

                    // ISSUE: Complex multi-step action required under time pressure
                    Text("Tap the buttons in order: 1 → 2 → 3 → 4")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Step \(currentStep + 1) of 4")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // 2x2 Grid of buttons
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            ChallengeButton(number: 1, currentStep: $currentStep, onCorrect: advanceStep)
                            ChallengeButton(number: 2, currentStep: $currentStep, onCorrect: advanceStep)
                        }
                        HStack(spacing: 20) {
                            ChallengeButton(number: 3, currentStep: $currentStep, onCorrect: advanceStep)
                            ChallengeButton(number: 4, currentStep: $currentStep, onCorrect: advanceStep)
                        }
                    }
                } else if hasWon {
                    VStack(spacing: 20) {
                        Text("🎊 You Won! 🎊")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)

                        Text("You get a free virtual cat!")
                            .font(.title3)
                            .foregroundColor(.white)

                        Button("Claim Prize") {
                            isPresented = false
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("⏰ Time's Up!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)

                        Text("Better luck next time!")
                            .font(.title3)
                            .foregroundColor(.white)

                        Button("Close") {
                            isPresented = false
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if !hasWon && !hasFailed {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    hasFailed = true
                }
            }
        }
    }

    func advanceStep() {
        currentStep += 1
        if currentStep >= 4 {
            hasWon = true
        }
    }
}

struct ChallengeButton: View {
    let number: Int
    @Binding var currentStep: Int
    let onCorrect: () -> Void

    var isActive: Bool {
        number == currentStep + 1
    }

    var isPast: Bool {
        number <= currentStep
    }

    var body: some View {
        Button(action: {
            if isActive {
                onCorrect()
            }
        }) {
            ZStack {
                Circle()
                    .fill(isPast ? Color.green : (isActive ? Color.blue : Color.gray))
                    .frame(width: 80, height: 80)

                if isPast {
                    Image(systemName: "checkmark")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                } else {
                    Text("\(number)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(!isActive)
    }
}

#Preview {
    TimeChallengeModal(isPresented: .constant(true))
}
