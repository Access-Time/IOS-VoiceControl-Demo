//
//  BrowseView.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import SwiftUI
import CoreMotion

struct BrowseView: View {
    @ObservedObject var viewModel: CatViewModel
    @State private var selectedImage: CatImage?
    @State private var isZoomed: Bool = false
    @State private var motionManager = CMMotionManager()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.browseImages) { catImage in
                            CatImageCell(catImage: catImage)
                                .onTapGesture {
                                    selectedImage = catImage
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Browse Cats")
            .sheet(item: $selectedImage) { catImage in
                ImageDetailView(
                    catImage: catImage,
                    isZoomed: $isZoomed,
                    onLike: {
                        viewModel.toggleLike(imageId: catImage.id)
                        selectedImage = nil
                    }
                )
            }
            .onAppear {
                startShakeDetection()
            }
            .onDisappear {
                stopShakeDetection()
            }
        }
    }

    // ISSUE: Shake gesture to like - not accessible via voice control
    private func startShakeDetection() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data = data else { return }
                let acceleration = data.acceleration
                let threshold = 2.5

                if abs(acceleration.x) > threshold || abs(acceleration.y) > threshold || abs(acceleration.z) > threshold {
                    if let selectedImage = selectedImage {
                        viewModel.toggleLike(imageId: selectedImage.id)
                    }
                }
            }
        }
    }

    private func stopShakeDetection() {
        motionManager.stopAccelerometerUpdates()
    }
}

struct CatImageCell: View {
    let catImage: CatImage

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(catImage.imageName)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .cornerRadius(10)

            if catImage.isLiked {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .padding(8)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ImageDetailView: View {
    let catImage: CatImage
    @Binding var isZoomed: Bool
    let onLike: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding()
            }

            Spacer()

            Image(catImage.imageName)
                .resizable()
                .aspectRatio(contentMode: isZoomed ? .fill : .fit)
                .cornerRadius(10)
                .scaleEffect(isZoomed ? 2.0 : 1.0)
                .animation(.spring(), value: isZoomed)
                .padding()
                .clipped()

            HStack(spacing: 30) {
                // ISSUE: Using magnifying glass (same icon as search)
                Button(action: { isZoomed.toggle() }) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }
            .padding()

            Text("Shake to like")
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()
        }
    }
}

#Preview {
    BrowseView(viewModel: CatViewModel())
}
