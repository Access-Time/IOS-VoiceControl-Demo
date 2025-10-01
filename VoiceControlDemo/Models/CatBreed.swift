//
//  CatBreed.swift
//  VoiceControlDemo
//
//  Created by Bogdan Sikora on 01.10.2025.
//

import Foundation

struct CatBreed: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let imageName: String

    init(id: UUID = UUID(), name: String, description: String, imageName: String) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
    }
}

struct CatImage: Identifiable {
    let id: UUID
    let imageName: String
    var isLiked: Bool

    init(id: UUID = UUID(), imageName: String, isLiked: Bool = false) {
        self.id = id
        self.imageName = imageName
        self.isLiked = isLiked
    }
}
