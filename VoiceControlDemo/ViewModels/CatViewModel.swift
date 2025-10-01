//
//  CatViewModel.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import Foundation
import SwiftUI

class CatViewModel: ObservableObject {
    @Published var catBreeds: [CatBreed] = []
    @Published var browseImages: [CatImage] = []
    @Published var swipeImages: [CatImage] = []
    @Published var currentSwipeIndex: Int = 0
    @Published var swipeLikeCount: Int = 0
    @Published var showTimeChallenge: Bool = false

    init() {
        loadCatBreeds()
        loadBrowseImages()
        loadSwipeImages()
    }

    private func loadCatBreeds() {
        catBreeds = [
            CatBreed(name: "Persian", description: "Long-haired, flat-faced cat breed", imageName: "IMG_8308"),
            CatBreed(name: "Siamese", description: "Vocal and social cat with blue eyes", imageName: "IMG_8347"),
            CatBreed(name: "Maine Coon", description: "Large, friendly cat with tufted ears", imageName: "IMG_8367"),
            CatBreed(name: "Bengal", description: "Wild-looking spotted cat breed", imageName: "IMG_8380"),
            CatBreed(name: "Ragdoll", description: "Gentle, floppy cat when picked up", imageName: "IMG_8382"),
            CatBreed(name: "British Shorthair", description: "Round-faced, plush coat cat", imageName: "IMG_8386"),
            CatBreed(name: "Scottish Fold", description: "Cat with distinctive folded ears", imageName: "IMG_8390"),
            CatBreed(name: "Sphynx", description: "Hairless cat with wrinkled skin", imageName: "IMG_8395")
        ]
    }

    private func loadBrowseImages() {
        let imageNames = ["IMG_8308", "IMG_8347", "IMG_8367", "IMG_8380", "IMG_8382", "IMG_8386",
                          "IMG_8390", "IMG_8395", "IMG_8403", "IMG_8404", "IMG_8553", "IMG_8563"]
        browseImages = imageNames.map { CatImage(imageName: $0) }
    }

    private func loadSwipeImages() {
        let imageNames = ["IMG_8308", "IMG_8347", "IMG_8367", "IMG_8380", "IMG_8382", "IMG_8386",
                          "IMG_8390", "IMG_8395", "IMG_8403", "IMG_8404", "IMG_8553", "IMG_8563",
                          "IMG_8565", "IMG_8566", "IMG_8567"]
        swipeImages = imageNames.map { CatImage(imageName: $0) }.shuffled()
    }

    func toggleLike(imageId: UUID) {
        if let index = browseImages.firstIndex(where: { $0.id == imageId }) {
            browseImages[index].isLiked.toggle()
        }
    }

    func swipeRight() {
        swipeLikeCount += 1
        if swipeLikeCount == 5 {
            showTimeChallenge = true
            swipeLikeCount = 0
        }
        nextSwipeImage()
    }

    func swipeLeft() {
        nextSwipeImage()
    }

    private func nextSwipeImage() {
        if currentSwipeIndex < swipeImages.count - 1 {
            currentSwipeIndex += 1
        } else {
            // Reload and shuffle
            loadSwipeImages()
            currentSwipeIndex = 0
        }
    }

    func searchBreeds(query: String) -> [CatBreed] {
        if query.isEmpty {
            return catBreeds
        }
        return catBreeds.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
}
