//
//  SwipeView.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import SwiftUI

struct SwipeView: View {
    @ObservedObject var viewModel: CatViewModel
    @State private var offset: CGSize = .zero
    @State private var swipeDirection: SwipeDirection?

    enum SwipeDirection {
        case left, right
    }

    var currentImage: CatImage? {
        guard viewModel.currentSwipeIndex < viewModel.swipeImages.count else { return nil }
        return viewModel.swipeImages[viewModel.currentSwipeIndex]
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()

                    if let image = currentImage {
                        // ISSUE: Swipe-only interaction - no button alternatives
                        ZStack {
                            CardView(catImage: image)
                                .offset(offset)
                                .rotationEffect(.degrees(Double(offset.width / 20)))
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            offset = gesture.translation

                                            if offset.width > 100 {
                                                swipeDirection = .right
                                            } else if offset.width < -100 {
                                                swipeDirection = .left
                                            } else {
                                                swipeDirection = nil
                                            }
                                        }
                                        .onEnded { _ in
                                            if offset.width > 150 {
                                                // Swipe right - like
                                                withAnimation {
                                                    offset.width = 500
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    viewModel.swipeRight()
                                                    offset = .zero
                                                    swipeDirection = nil
                                                }
                                            } else if offset.width < -150 {
                                                // Swipe left - dislike
                                                withAnimation {
                                                    offset.width = -500
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    viewModel.swipeLeft()
                                                    offset = .zero
                                                    swipeDirection = nil
                                                }
                                            } else {
                                                // Return to center
                                                withAnimation {
                                                    offset = .zero
                                                    swipeDirection = nil
                                                }
                                            }
                                        }
                                )

                            // Show overlay indicators
                            if let direction = swipeDirection {
                                OverlayIndicator(direction: direction)
                            }
                        }
                        .frame(height: 500)
                    }

                    Spacer()

                    // Instructions (but no actual buttons!)
                    Text("Swipe right to like, left to pass")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Swipe Cats")
        }
    }
}

struct CardView: View {
    let catImage: CatImage

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)

            VStack {
                Image(catImage.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 420)
                    .cornerRadius(15)
                    .clipped()
                    .padding()

                Text("Cute Cat")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom)
            }
        }
        .frame(width: 350, height: 500)
    }
}

struct OverlayIndicator: View {
    let direction: SwipeView.SwipeDirection

    var body: some View {
        ZStack {
            if direction == .right {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green, lineWidth: 5)
                    .overlay(
                        Text("LIKE")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.green)
                            .rotationEffect(.degrees(-25))
                    )
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red, lineWidth: 5)
                    .overlay(
                        Text("NOPE")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.red)
                            .rotationEffect(.degrees(25))
                    )
            }
        }
        .frame(width: 350, height: 500)
    }
}

#Preview {
    SwipeView(viewModel: CatViewModel())
}
